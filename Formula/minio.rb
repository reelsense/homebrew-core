class Minio < Formula
  desc "Amazon S3 compatible object storage server"
  homepage "https://github.com/minio/minio"
  url "https://github.com/minio/minio.git",
      :tag => "RELEASE.2017-06-13T19-01-01Z",
      :revision => "b9f622824ac17d3e0577d8a9b81a707666cc8cf1"
  version "20170613190101"

  bottle do
    cellar :any_skip_relocation
    sha256 "3884d5b7aab0fa796f345a96aa729fece5dc4d058afd0409b18a62e35b3f7cf5" => :sierra
    sha256 "4a195f448f4a9de8076feb5aa77401a666fddb93062630f8f2081923cdb20f55" => :el_capitan
    sha256 "5af5f770c4b9a5a6faf08e08822e21e19f1d1d080cb7a89428d4cbf64adbd968" => :yosemite
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    clipath = buildpath/"src/github.com/minio/minio"
    clipath.install Dir["*"]

    cd clipath do
      if build.head?
        system "go", "build", "-o", buildpath/"minio"
      else
        release = `git tag --points-at HEAD`.chomp
        version = release.gsub(/RELEASE\./, "").chomp.gsub(/T(\d+)\-(\d+)\-(\d+)Z/, 'T\1:\2:\3Z')
        commit = `git rev-parse HEAD`.chomp
        proj = "github.com/minio/minio"

        system "go", "build", "-o", buildpath/"minio", "-ldflags", <<-EOS.undent
            -X #{proj}/cmd.Version=#{version}
            -X #{proj}/cmd.ReleaseTag=#{release}
            -X #{proj}/cmd.CommitID=#{commit}
            EOS
      end
    end

    bin.install buildpath/"minio"
  end

  def post_install
    (var/"minio").mkpath
    (etc/"minio").mkpath
  end

  plist_options :manual => "minio server"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
   <plist version="1.0">
    <dict>
      <key>KeepAlive</key>
      <true/>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>ProgramArguments</key>
      <array>
        <string>#{opt_bin}/minio</string>
        <string>server</string>
        <string>--config-dir=#{etc}/minio</string>
        <string>--address :9000</string>
        <string>#{var}/minio</string>
      </array>
      <key>RunAtLoad</key>
      <true/>
      <key>KeepAlive</key>
      <true/>
      <key>WorkingDirectory</key>
      <string>#{HOMEBREW_PREFIX}</string>
      <key>StandardErrorPath</key>
      <string>#{var}/log/minio/output.log</string>
      <key>StandardOutPath</key>
      <string>#{var}/log/minio/output.log</string>
      <key>RunAtLoad</key>
      <true/>
    </dict>
    </plist>
    EOS
  end

  test do
    system "#{bin}/minio", "version"
  end
end
