class Corebird < Formula
  desc "Native Gtk+ Twitter Client"
  homepage "https://corebird.baedert.org"
  url "https://github.com/baedert/corebird/releases/download/1.4.2/corebird-1.4.2.tar.xz"
  sha256 "1c07a65382e78308f7de406be8464789c1ec42d531c519b69510a685234b4074"

  bottle do
    sha256 "a7401a2c8a4b172978e5a4eaa7f895c18ab97292188018f30ad7c6da93fabe94" => :sierra
    sha256 "bd5c64459452e1890f6dce1faf0bbf3bc86bd95419d7f3042d37a68e28514f6b" => :el_capitan
    sha256 "b40a0f4f3779ea105d2ace59490de15a18f3cee8be4dca61c29eb85d58e2c905" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "vala" => :build
  depends_on "gtk+3"
  depends_on "librest"
  depends_on "libsoup"
  depends_on "json-glib"
  depends_on "gspell"
  depends_on "gst-plugins-good"
  depends_on "gst-plugins-bad"
  depends_on "gst-plugins-base"
  depends_on "gst-libav"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--disable-schemas-compile",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
    system "#{Formula["gtk+3"].opt_bin}/gtk3-update-icon-cache", "-f", "-t", "#{HOMEBREW_PREFIX}/share/icons/hicolor"
  end

  test do
    system "#{bin}/corebird", "--help"
  end
end
