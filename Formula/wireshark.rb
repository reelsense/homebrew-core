class Wireshark < Formula
  desc "Graphical network analyzer and capture tool"
  homepage "https://www.wireshark.org"
  url "https://www.wireshark.org/download/src/all-versions/wireshark-2.2.5.tar.bz2"
  mirror "https://1.eu.dl.wireshark.org/src/wireshark-2.2.5.tar.bz2"
  sha256 "75dd88d3d6336559e5b0b72077d8a772a988197d571f00029986225fef609ac8"
  head "https://code.wireshark.org/review/wireshark", :using => :git

  bottle do
    sha256 "9f633d3e21c1884af106ba0836ce46f66309bb60e7846f14fd32929a4dd00b44" => :sierra
    sha256 "bc39656140e7433130d43eafd333e7f0f67477ee347115e597a61c14ca4c632d" => :el_capitan
    sha256 "981787888b59091393fc3355476232bc89ed5a79937518df5552ba14413f2571" => :yosemite
  end

  option "with-gtk+3", "Build the wireshark command with gtk+3"
  option "with-gtk+", "Build the wireshark command with gtk+"
  option "with-qt5", "Build the wireshark command with Qt5 (can be used with or without either GTK option)"
  option "with-headers", "Install Wireshark library headers for plug-in development"

  deprecated_option "with-qt" => "with-qt5"

  depends_on "pkg-config" => :build
  depends_on "cmake" => :build
  depends_on "glib"
  depends_on "gnutls"
  depends_on "libgcrypt"
  depends_on "dbus"
  depends_on "geoip" => :recommended
  depends_on "c-ares" => :recommended
  depends_on "libsmi" => :optional
  depends_on "lua" => :optional
  depends_on "portaudio" => :optional
  depends_on "qt5" => :optional
  depends_on "gtk+3" => :optional
  depends_on "gtk+" => :optional
  depends_on "gnome-icon-theme" if build.with? "gtk+3"

  resource "libpcap" do
    url "http://www.tcpdump.org/release/libpcap-1.8.0.tar.gz"
    sha256 "f47b51533f9f060afb304010ea5cbf51d032707333bca70c36351d255754659c"
  end

  def install
    if MacOS.version <= :mavericks
      resource("libpcap").stage do
        system "./configure", "--prefix=#{libexec}/vendor",
                              "--enable-ipv6",
                              "--disable-universal"
        system "make", "install"
      end
      ENV.prepend_path "PATH", libexec/"vendor/bin"
      ENV.prepend "CFLAGS", "-I#{libexec}/vendor/include"
      ENV.prepend "LDFLAGS", "-L#{libexec}/vendor/lib"
    end

    args = std_cmake_args
    args << "-DENABLE_GNUTLS=ON" << "-DENABLE_GCRYPT=ON"

    if build.with? "qt5"
      args << "-DBUILD_wireshark=ON"
      args << "-DENABLE_APPLICATION_BUNDLE=ON"
      args << "-DENABLE_QT5=ON"
    else
      args << "-DBUILD_wireshark=OFF"
      args << "-DENABLE_APPLICATION_BUNDLE=OFF"
    end

    if build.with?("gtk+3") || build.with?("gtk+")
      args << "-DBUILD_wireshark_gtk=ON"
      args << "-DENABLE_GTK3=" + (build.with?("gtk+3") ? "ON" : "OFF")
      args << "-DENABLE_PORTAUDIO=ON" if build.with? "portaudio"
    else
      args << "-DBUILD_wireshark_gtk=OFF"
      args << "-DENABLE_PORTAUDIO=OFF"
    end

    if build.with? "geoip"
      args << "-DENABLE_GEOIP=ON"
    else
      args << "-DENABLE_GEOIP=OFF"
    end

    if build.with? "c-ares"
      args << "-DENABLE_CARES=ON"
    else
      args << "-DENABLE_CARES=OFF"
    end

    if build.with? "libsmi"
      args << "-DENABLE_SMI=ON"
    else
      args << "-DENABLE_SMI=OFF"
    end

    if build.with? "lua"
      args << "-DENABLE_LUA=ON"
    else
      args << "-DENABLE_LUA=OFF"
    end

    system "cmake", *args
    system "make"
    ENV.deparallelize # parallel install fails
    system "make", "install"

    if build.with? "qt5"
      prefix.install bin/"Wireshark.app"
      bin.install_symlink prefix/"Wireshark.app/Contents/MacOS/Wireshark"
    end

    if build.with? "headers"
      (include/"wireshark").install Dir["*.h"]
      (include/"wireshark/epan").install Dir["epan/*.h"]
      (include/"wireshark/epan/crypt").install Dir["epan/crypt/*.h"]
      (include/"wireshark/epan/dfilter").install Dir["epan/dfilter/*.h"]
      (include/"wireshark/epan/dissectors").install Dir["epan/dissectors/*.h"]
      (include/"wireshark/epan/ftypes").install Dir["epan/ftypes/*.h"]
      (include/"wireshark/epan/wmem").install Dir["epan/wmem/*.h"]
      (include/"wireshark/wiretap").install Dir["wiretap/*.h"]
      (include/"wireshark/wsutil").install Dir["wsutil/*.h"]
    end
  end

  def caveats; <<-EOS.undent
    If your list of available capture interfaces is empty
    (default macOS behavior), try installing ChmodBPF from homebrew cask:

      brew cask install wireshark-chmodbpf

    This creates an 'access_bpf' group and adds a launch daemon that changes the
    permissions of your BPF devices so that all users in that group have both
    read and write access to those devices.

    See bug report:
      https://bugs.wireshark.org/bugzilla/show_bug.cgi?id=3760
    EOS
  end

  test do
    system bin/"randpkt", "-b", "100", "-c", "2", "capture.pcap"
    output = shell_output("#{bin}/capinfos -Tmc capture.pcap")
    assert_equal "File name,Number of packets\ncapture.pcap,2\n", output
  end
end
