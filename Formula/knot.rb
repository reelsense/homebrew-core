class Knot < Formula
  desc "High-performance authoritative-only DNS server"
  homepage "https://www.knot-dns.cz/"

  stable do
    url "https://secure.nic.cz/files/knot-dns/knot-2.4.3.tar.xz"
    sha256 "f90258bcb29c1f351cd8d824ff8d67aef906ae5d5ff0f652c4f69c69ed8a704f"

    resource "fstrm" do
      url "https://dl.farsightsecurity.com/dist/fstrm/fstrm-0.3.2.tar.gz"
      sha256 "2d509999ac904e48c038f88820f47859da85ceb86c06552e4052897082423ec5"
    end
  end

  bottle do
    sha256 "e0a392eb217d4707174b5319bd5c87a1b6ec4a1c8a05f2e8513d1b8827fe0a5f" => :sierra
    sha256 "25af8be672f352e88edfb9f41d5a2fc2ac74e99e333a451c08080fccfa51a509" => :el_capitan
    sha256 "fc92515ae8adb4bbcc75629fb525d34935686877352d86ee50797485429d1c9c" => :yosemite
  end

  head do
    url "https://gitlab.labs.nic.cz/labs/knot.git"

    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build

    resource "fstrm" do
      url "https://github.com/farsightsec/fstrm.git"
    end
  end

  # due to AT_REMOVEDIR
  depends_on :macos => :yosemite

  depends_on "pkg-config" => :build
  depends_on "sphinx-doc" => :build
  depends_on "gnutls"
  depends_on "jansson"
  depends_on "libidn"
  depends_on "nettle"
  depends_on "openssl"
  depends_on "userspace-rcu"
  depends_on "protobuf-c"
  depends_on "libevent"

  def install
    resource("fstrm").stage do
      system "autoreconf", "-fvi" if build.head?
      system "./configure", "--prefix=#{libexec}/fstrm"
      system "make", "install"
    end

    ENV.append "CFLAGS", "-I#{libexec}/fstrm/include"
    ENV.append "LDFLAGS", "-L#{libexec}/fstrm/lib"
    ENV.append_path "PKG_CONFIG_PATH", "#{libexec}/fstrm/lib/pkgconfig"

    system "autoreconf", "-fvi" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--with-configdir=#{etc}",
                          "--with-storage=#{var}/knot",
                          "--with-rundir=#{var}/run/knot",
                          "--prefix=#{prefix}",
                          "--with-bash-completions=#{bash_completion}",
                          "--enable-dnstap"

    inreplace "samples/Makefile", "install-data-local:", "disable-install-data-local:"

    system "make"
    system "make", "check"
    system "make", "install"
    system "make", "install-singlehtml"

    (buildpath/"knot.conf").write(knot_conf)
    etc.install "knot.conf"
  end

  def post_install
    (var/"knot").mkpath
  end

  def knot_conf; <<-EOS.undent
    server:
      rundir: "#{var}/knot"
      listen: [ "0.0.0.0@53", "::@53" ]

    log:
      - target: "stderr"
        any: "info"

    control:
      listen: "knot.sock"

    template:
      - id: "default"
        storage: "#{var}/knot"
    EOS
  end

  plist_options :startup => true

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>EnableTransactions</key>
      <true/>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>RunAtLoad</key>
      <true/>
      <key>ProgramArguments</key>
      <array>
        <string>#{opt_sbin}/knotd</string>
        <string>-c</string>
        <string>#{etc}/knot.conf</string>
      </array>
      <key>StandardInPath</key>
      <string>/dev/null</string>
      <key>StandardOutPath</key>
      <string>/dev/null</string>
      <key>StandardErrorPath</key>
      <string>#{var}/log/knot.log</string>
    </dict>
    </plist>
    EOS
  end

  test do
    system bin/"kdig", "www.knot-dns.cz"
    system bin/"khost", "brew.sh"
    system sbin/"knotc", "-c", etc/"knot.conf", "conf-check"
  end
end
