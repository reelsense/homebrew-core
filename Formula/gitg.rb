class Gitg < Formula
  desc "GNOME GUI client to view git repositories"
  homepage "https://wiki.gnome.org/Apps/Gitg"
  url "https://download.gnome.org/sources/gitg/3.24/gitg-3.24.0.tar.xz"
  sha256 "3e4ec4a8ae83bc7ced8c7610927ade70e37daa5e8beeb4f357a6ea30b4cc951e"
  revision 1

  bottle do
    sha256 "37b53b2a0dfce8ad4a6e3304c72185bf2fa013b95263961cabf201b5a5bedb66" => :sierra
    sha256 "272739068c087d1f6d5998712afa64c1b613cf93db47f8f82508ca082455f7a8" => :el_capitan
    sha256 "d5b885cbe513aeee2f6b8ea3f09321b0a8b4e455985ec998ff55765820c40d50" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "vala" => :build
  depends_on "intltool" => :build
  depends_on "gtksourceview3"
  depends_on "gobject-introspection"
  depends_on "libgit2"
  depends_on "libgit2-glib"
  depends_on "gsettings-desktop-schemas"
  depends_on "libgee"
  depends_on "json-glib"
  depends_on "libsecret"
  depends_on "libpeas"
  depends_on "libsoup"
  depends_on "gtkspell3"
  depends_on "hicolor-icon-theme"
  depends_on "gnome-icon-theme"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--disable-schemas-compile",
                          "--disable-python"
    system "make", "install"
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
    system "#{Formula["gtk+3"].opt_bin}/gtk3-update-icon-cache", "-f", "-t", "#{HOMEBREW_PREFIX}/share/icons/hicolor"
  end

  test do
    # test executable
    assert_match version.to_s, shell_output("#{bin}/gitg --version")
    # test API
    (testpath/"test.c").write <<-EOS.undent
      #include <libgitg/libgitg.h>

      int main(int argc, char *argv[]) {
        GType gtype = gitg_stage_status_file_get_type();
        return 0;
      }
    EOS
    atk = Formula["atk"]
    cairo = Formula["cairo"]
    fontconfig = Formula["fontconfig"]
    freetype = Formula["freetype"]
    gdk_pixbuf = Formula["gdk-pixbuf"]
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    gobject_introspection = Formula["gobject-introspection"]
    gtkx3 = Formula["gtk+3"]
    harfbuzz = Formula["harfbuzz"]
    libepoxy = Formula["libepoxy"]
    libffi = Formula["libffi"]
    libgee = Formula["libgee"]
    libgit2 = Formula["libgit2-glib"].opt_libexec/"libgit2"
    libgit2_glib = Formula["libgit2-glib"]
    libpng = Formula["libpng"]
    libsoup = Formula["libsoup"]
    pango = Formula["pango"]
    pixman = Formula["pixman"]
    flags = %W[
      -I#{atk.opt_include}/atk-1.0
      -I#{cairo.opt_include}/cairo
      -I#{fontconfig.opt_include}
      -I#{freetype.opt_include}/freetype2
      -I#{gdk_pixbuf.opt_include}/gdk-pixbuf-2.0
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/gio-unix-2.0/
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{gobject_introspection.opt_include}/gobject-introspection-1.0
      -I#{gtkx3.opt_include}/gtk-3.0
      -I#{harfbuzz.opt_include}/harfbuzz
      -I#{include}/libgitg-1.0
      -I#{libepoxy.opt_include}
      -I#{libgee.opt_include}/gee-0.8
      -I#{libffi.opt_lib}/libffi-3.0.13/include
      -I#{libgit2}/include
      -I#{libgit2_glib.opt_include}/libgit2-glib-1.0
      -I#{libpng.opt_include}/libpng16
      -I#{libsoup.opt_include}/libsoup-2.4
      -I#{pango.opt_include}/pango-1.0
      -I#{pixman.opt_include}/pixman-1
      -DGIT_SSH=1
      -D_REENTRANT
      -L#{atk.opt_lib}
      -L#{cairo.opt_lib}
      -L#{gdk_pixbuf.opt_lib}
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{gobject_introspection.opt_lib}
      -L#{gtkx3.opt_lib}
      -L#{libgee.opt_lib}
      -L#{libgit2}/lib
      -L#{libgit2_glib.opt_lib}
      -L#{libsoup.opt_lib}
      -L#{lib}
      -L#{pango.opt_lib}
      -latk-1.0
      -lcairo
      -lcairo-gobject
      -lgdk-3
      -lgdk_pixbuf-2.0
      -lgio-2.0
      -lgirepository-1.0
      -lgit2
      -lgit2-glib-1.0
      -lgitg-1.0
      -lglib-2.0
      -lgmodule-2.0
      -lgobject-2.0
      -lgthread-2.0
      -lgtk-3
      -lintl
      -lpango-1.0
      -lpangocairo-1.0
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
