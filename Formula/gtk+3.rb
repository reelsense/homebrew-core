class Gtkx3 < Formula
  desc "Toolkit for creating graphical user interfaces"
  homepage "https://gtk.org/"
  url "https://download.gnome.org/sources/gtk+/3.22/gtk+-3.22.15.tar.xz"
  sha256 "c8a012c2a99132629ab043f764a2b7cb6388483a015cd15c7a4288bec3590fdb"

  bottle do
    sha256 "5ebc52a5731f83fdf0137a3acb8508a67453deabd47fd7b293600dbf3e40ad18" => :sierra
    sha256 "dd4ef2c3f8d495389daaf257cb19b85f4d7c82c126d9ee8c6a74ad84b5120869" => :el_capitan
    sha256 "1be3c9d2ff82bdfd97f27a4a90f3eb8080b9da7719bbcb0dc6baa06fb5d9bf53" => :yosemite
  end

  # see https://bugzilla.gnome.org/show_bug.cgi?id=781118
  patch :DATA

  option "with-quartz-relocation", "Build with quartz relocation support"

  depends_on "pkg-config" => :build
  depends_on "gdk-pixbuf"
  depends_on "atk"
  depends_on "gobject-introspection"
  depends_on "libepoxy"
  depends_on "pango"
  depends_on "glib"
  depends_on "hicolor-icon-theme"
  depends_on "gsettings-desktop-schemas" => :recommended
  depends_on "jasper" => :optional

  def install
    args = %W[
      --enable-debug=minimal
      --disable-dependency-tracking
      --prefix=#{prefix}
      --disable-glibtest
      --enable-introspection=yes
      --disable-schemas-compile
      --enable-quartz-backend
      --disable-x11-backend
    ]

    args << "--enable-quartz-relocation" if build.with?("quartz-relocation")

    system "./configure", *args
    # necessary to avoid gtk-update-icon-cache not being found during make install
    bin.mkpath
    ENV.prepend_path "PATH", bin
    system "make", "install"
    # Prevent a conflict between this and Gtk+2
    mv bin/"gtk-update-icon-cache", bin/"gtk3-update-icon-cache"
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <gtk/gtk.h>

      int main(int argc, char *argv[]) {
        gtk_disable_setlocale();
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
    libepoxy = Formula["libepoxy"]
    libpng = Formula["libpng"]
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
      -I#{include}
      -I#{include}/gtk-3.0
      -I#{libepoxy.opt_include}
      -I#{libpng.opt_include}/libpng16
      -I#{pango.opt_include}/pango-1.0
      -I#{pixman.opt_include}/pixman-1
      -D_REENTRANT
      -L#{atk.opt_lib}
      -L#{cairo.opt_lib}
      -L#{gdk_pixbuf.opt_lib}
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{lib}
      -L#{pango.opt_lib}
      -latk-1.0
      -lcairo
      -lcairo-gobject
      -lgdk-3
      -lgdk_pixbuf-2.0
      -lgio-2.0
      -lglib-2.0
      -lgobject-2.0
      -lgtk-3
      -lintl
      -lpango-1.0
      -lpangocairo-1.0
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end

__END__
diff --git a/gdk/quartz/gdkscreen-quartz.c b/gdk/quartz/gdkscreen-quartz.c
index 586f7af..d032643 100644
--- a/gdk/quartz/gdkscreen-quartz.c
+++ b/gdk/quartz/gdkscreen-quartz.c
@@ -79,7 +79,7 @@ gdk_quartz_screen_init (GdkQuartzScreen *quartz_screen)
   NSDictionary *dd = [[[NSScreen screens] objectAtIndex:0] deviceDescription];
   NSSize size = [[dd valueForKey:NSDeviceResolution] sizeValue];

-  _gdk_screen_set_resolution (screen, size.width);
+  _gdk_screen_set_resolution (screen, 72.0);

   gdk_quartz_screen_calculate_layout (quartz_screen);

@@ -334,11 +334,8 @@ gdk_quartz_screen_get_height (GdkScreen *screen)
 static gint
 get_mm_from_pixels (NSScreen *screen, int pixels)
 {
-  const float mm_per_inch = 25.4;
-  NSDictionary *dd = [[[NSScreen screens] objectAtIndex:0] deviceDescription];
-  NSSize size = [[dd valueForKey:NSDeviceResolution] sizeValue];
-  float dpi = size.width;
-  return (pixels / dpi) * mm_per_inch;
+  const float dpi = 72.0;
+  return (pixels / dpi) * 25.4;
 }

 static gchar *
