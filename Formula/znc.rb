class Znc < Formula
  desc "Advanced IRC bouncer"
  homepage "http://wiki.znc.in/ZNC"
  url "http://znc.in/releases/archive/znc-1.6.4.tar.gz"
  sha256 "431097eb17860bfc980f3e68fdd75f98af4bdeecd793c84835c6cb11c3320d1c"

  bottle do
    sha256 "ad6525de1af7124c52cdfeaff081b4dd5cc27d3d1a103f9a9176b60f1abc6eb8" => :sierra
    sha256 "9c86ce7f15a7c406b651df4620f142442360f4081e539fecb0d01174bc6285ad" => :el_capitan
    sha256 "c06d6e98751e9339b42cc7b1fc6844e618b9992465574186b22a66ba93becbb7" => :yosemite
  end

  head do
    url "https://github.com/znc/znc.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  option "with-debug", "Compile ZNC with debug support"
  option "with-icu4c", "Build with icu4c for charset support"

  deprecated_option "enable-debug" => "with-debug"

  depends_on "pkg-config" => :build
  depends_on "openssl"
  depends_on "icu4c" => :optional

  needs :cxx11

  def install
    ENV.cxx11
    # These need to be set in CXXFLAGS, because ZNC will embed them in its
    # znc-buildmod script; ZNC's configure script won't add the appropriate
    # flags itself if they're set in superenv and not in the environment.
    ENV.append "CXXFLAGS", "-std=c++11"
    ENV.append "CXXFLAGS", "-stdlib=libc++" if ENV.compiler == :clang

    args = ["--prefix=#{prefix}"]
    args << "--enable-debug" if build.with? "debug"

    system "./autogen.sh" if build.head?
    system "./configure", *args
    system "make", "install"
  end

  plist_options :manual => "znc --foreground"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_bin}/znc</string>
          <string>--foreground</string>
        </array>
        <key>StandardErrorPath</key>
        <string>#{var}/log/znc.log</string>
        <key>StandardOutPath</key>
        <string>#{var}/log/znc.log</string>
        <key>RunAtLoad</key>
        <true/>
        <key>StartInterval</key>
        <integer>300</integer>
      </dict>
    </plist>
    EOS
  end

  test do
    mkdir ".znc"
    system bin/"znc", "--makepem"
    assert File.exist?(".znc/znc.pem")
  end
end
