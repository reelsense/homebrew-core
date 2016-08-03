class Qjackctl < Formula
  desc "simple Qt application to control the JACK sound server daemon"
  homepage "http://qjackctl.sourceforge.net"
  url "https://downloads.sourceforge.net/qjackctl/qjackctl-0.4.2.tar.gz"
  sha256 "cf1c4aff22f8410feba9122e447b1e28c8fa2c71b12cfc0551755d351f9eaf5e"
  head "http://git.code.sf.net/p/qjackctl/code.git"

  bottle do
    revision 1
    sha256 "e27bb026a0a677ce7dbe4483fbf53a0bdad929da0007166790b6006cee0cf27a" => :el_capitan
    sha256 "531fcdb68a7436858e2b891dd0edacceed7bf084b0aadba046879d44fbf03bcd" => :yosemite
    sha256 "1b12ec7026cf50ed6b29726c60731f4bb1f22e39e62efe1569547dcb0f2b239a" => :mavericks
  end

  depends_on "autoconf" => :build
  depends_on "qt5"
  depends_on "jack"

  # Fixes varaible length array error with LLVM/Clang
  # Reported upstream: https://github.com/rncbc/qjackctl/issues/17
  patch do
    url "https://github.com/rncbc/qjackctl/commit/e92de08f7fd7c62ff1fb4f0330583f321a2a9aae.patch"
    sha256 "cbb7cc72e0086b8e6df24c8c3a462dc0e9297f095573adb7a3cf98502a1902d4"
  end

  def install
    system "./autogen.sh"
    system "./configure", "--disable-debug",
                          "--enable-qt5",
                          "--disable-dbus",
                          "--disable-xunique",
                          "--prefix=#{prefix}",
                          "--with-qt5=#{Formula["qt5"].opt_prefix}"

    system "make", "install"
    prefix.install bin/"qjackctl.app"
    bin.install_symlink prefix/"qjackctl.app/Contents/MacOS/qjackctl"
  end

  test do
    output = shell_output("#{bin}/qjackctl --version 2>&1", 1)
    assert_match version.to_s, output
  end
end
