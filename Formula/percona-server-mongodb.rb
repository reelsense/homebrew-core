require "language/go"

class PerconaServerMongodb < Formula
  desc "Drop-in MongoDB replacement"
  homepage "https://www.percona.com"
  url "https://www.percona.com/downloads/percona-server-mongodb-3.4/percona-server-mongodb-3.4.6-1.7/source/tarball/percona-server-mongodb-3.4.6-1.7.tar.gz"
  version "3.4.6-1.7"
  sha256 "9449d0bfb88e23a4bce0e5ffb223fa5177ba726c2780d073c30256f148123c18"

  bottle do
    sha256 "4f8584a9fc8b0402a4bada8d041770d1bee7ffb9030c3efc46c2305904945d2e" => :sierra
    sha256 "ec4178729fc29a29dc072030e65fba5f44712e710f13d0f555012bb172281193" => :el_capitan
    sha256 "b5d381035b34393152671018e743a4b80aca5f6ea6f00c7e86880e242929cf5d" => :yosemite
  end

  option "with-boost", "Compile using installed boost, not the version shipped with this formula"
  option "with-sasl", "Compile with SASL support"

  depends_on "boost" => :optional
  depends_on "go" => :build
  depends_on :macos => :mountain_lion
  depends_on "scons" => :build
  depends_on "openssl" => :recommended

  conflicts_with "mongodb",
    :because => "percona-server-mongodb and mongodb install the same binaries."

  go_resource "github.com/mongodb/mongo-tools" do
    url "https://github.com/mongodb/mongo-tools.git",
        :tag => "r3.4.5",
        :revision => "4d4d96583c40a25a4ee7e2d038d75181a300ec3c",
        :shallow => false
  end

  needs :cxx11

  def install
    ENV.cxx11 if MacOS.version < :mavericks
    ENV.libcxx if build.devel?

    # New Go tools have their own build script but the server scons "install" target is still
    # responsible for installing them.
    Language::Go.stage_deps resources, buildpath/"src"

    cd "src/github.com/mongodb/mongo-tools" do
      args = %w[]

      if build.with? "openssl"
        args << "ssl"
        ENV["LIBRARY_PATH"] = Formula["openssl"].opt_lib
        ENV["CPATH"] = Formula["openssl"].opt_include
      end

      args << "sasl" if build.with? "sasl"

      system "./build.sh", *args
    end

    (buildpath/"src/mongo-tools").install Dir["src/github.com/mongodb/mongo-tools/bin/*"]

    args = %W[
      --prefix=#{prefix}
      -j#{ENV.make_jobs}
      --osx-version-min=#{MacOS.version}
    ]

    args << "CC=#{ENV.cc}"
    args << "CXX=#{ENV.cxx}"

    args << "--use-sasl-client" if build.with? "sasl"
    args << "--use-system-boost" if build.with? "boost"
    args << "--use-new-tools"
    args << "--disable-warnings-as-errors" if MacOS.version >= :yosemite

    if build.with? "openssl"
      args << "--ssl"

      args << "CCFLAGS=-I#{Formula["openssl"].opt_include}"
      args << "LINKFLAGS=-L#{Formula["openssl"].opt_lib}"
    end

    scons "install", *args

    (buildpath/"mongod.conf").write <<-EOS.undent
      systemLog:
        destination: file
        path: #{var}/log/mongodb/mongo.log
        logAppend: true
      storage:
        dbPath: #{var}/mongodb
      net:
        bindIp: 127.0.0.1
    EOS
    etc.install "mongod.conf"
  end

  def post_install
    (var/"mongodb").mkpath
    (var/"log/mongodb").mkpath
  end

  plist_options :manual => "mongod --config #{HOMEBREW_PREFIX}/etc/mongod.conf"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>ProgramArguments</key>
      <array>
        <string>#{opt_bin}/mongod</string>
        <string>--config</string>
        <string>#{etc}/mongod.conf</string>
      </array>
      <key>RunAtLoad</key>
      <true/>
      <key>KeepAlive</key>
      <false/>
      <key>WorkingDirectory</key>
      <string>#{HOMEBREW_PREFIX}</string>
      <key>StandardErrorPath</key>
      <string>#{var}/log/mongodb/output.log</string>
      <key>StandardOutPath</key>
      <string>#{var}/log/mongodb/output.log</string>
      <key>HardResourceLimits</key>
      <dict>
        <key>NumberOfFiles</key>
        <integer>4096</integer>
      </dict>
      <key>SoftResourceLimits</key>
      <dict>
        <key>NumberOfFiles</key>
        <integer>4096</integer>
      </dict>
    </dict>
    </plist>
    EOS
  end

  test do
    begin
      (testpath/"mongodb_test.js").write <<-EOS.undent
        printjson(db.getCollectionNames())
        // create test collection
        db.test.insertOne(
          {
            "name": "test"
          }
        )
        printjson(db.getCollectionNames())
        // shows documents
        cursor = db.test.find({})
        while (cursor.hasNext()) {
          printjson(cursor.next())
        }
        db.test.deleteMany({})
        // drop test collection
        db.test.drop()
        printjson(db.getCollectionNames())
      EOS
      pid = fork do
        exec "#{bin}/mongod", "--port", "27018", "--dbpath", testpath
      end
      sleep 1
      system "#{bin}/mongo", "localhost:27018", testpath/"mongodb_test.js"
    ensure
      Process.kill "SIGTERM", pid
      Process.wait pid
    end
  end
end
