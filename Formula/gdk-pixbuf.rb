class GdkPixbuf < Formula
  desc "Toolkit for image loading and pixel buffer manipulation"
  homepage "http://gtk.org"
  url "https://download.gnome.org/sources/gdk-pixbuf/2.34/gdk-pixbuf-2.34.0.tar.xz"
  sha256 "d55e5b383ee219bd0e23bf6ed4427d56a7db5379729a6e3e0a0e0eba9a8d8879"

  bottle do
    sha256 "2457c164f46d315b58ed69358973c78139af3422205f7376a777d16e43ceb7da" => :el_capitan
    sha256 "15096f218ea453b77ae40d88752610742d78d199b2b90fa1c5323eeb547dd394" => :yosemite
    sha256 "57cc04ff998e51dc3004656c2f44cf2820d5002cfdc18f7a7dc6e04e674315ab" => :mavericks
  end

  option :universal
  option "with-relocations", "Build with relocation support for bundles"

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "jpeg"
  depends_on "libtiff"
  depends_on "libpng"
  depends_on "gobject-introspection"

  # 'loaders.cache' must be writable by other packages
  skip_clean "lib/gdk-pixbuf-2.0"

  # Patch that fixes an occasional segfault in Freeciv
  # See:
  # - https://bugzilla.gnome.org/show_bug.cgi?id=766842
  # - https://gna.org/bugs/?func=detailitem&item_id=24298
  patch do
    url "https://github.com/GNOME/gdk-pixbuf/commit/ad43d54b11d0b337e8032d9d25b09eb8f8650ace.patch"
    sha256 "c38cbf14bee68a15a12edb55a5fa39e36a8dc3d82b4160e9cefea921eda6a13d"
  end

  # gdk-pixbuf has an internal version number separate from the overall
  # version number that specifies the location of its module and cache
  # files, this will need to be updated if that internal version number
  # is ever changed (as evidenced by the location no longer existing)
  def gdk_so_ver
    "2.0"
  end

  def gdk_module_ver
    "2.10.0"
  end

  def install
    ENV.universal_binary if build.universal?
    ENV.append_to_cflags "-DGDK_PIXBUF_LIBDIR=\\\"#{HOMEBREW_PREFIX}/lib\\\""
    args = %W[
      --disable-dependency-tracking
      --disable-maintainer-mode
      --enable-debug=no
      --prefix=#{prefix}
      --enable-introspection=yes
      --disable-Bsymbolic
      --enable-static
      --without-gdiplus
    ]

    args << "--enable-relocations" if build.with?("relocations")

    system "./configure", *args
    system "make"
    system "make", "install"

    # Other packages should use the top-level modules directory
    # rather than dumping their files into the gdk-pixbuf keg.
    inreplace lib/"pkgconfig/gdk-pixbuf-#{gdk_so_ver}.pc" do |s|
      libv = s.get_make_var "gdk_pixbuf_binary_version"
      s.change_make_var! "gdk_pixbuf_binarydir",
        HOMEBREW_PREFIX/"lib/gdk-pixbuf-#{gdk_so_ver}"/libv
    end

    # Remove the cache. We will regenerate it in post_install
    (lib/"gdk-pixbuf-#{gdk_so_ver}/#{gdk_module_ver}/loaders.cache").unlink
  end

  # Where we want to store the loaders.cache file, which should be in a
  # Keg-specific lib directory, not in the global Homebrew lib directory
  def module_file
    "#{lib}/gdk-pixbuf-#{gdk_so_ver}/#{gdk_module_ver}/loaders.cache"
  end

  # The directory that loaders.cache gets linked into, also has the "loaders"
  # directory that is scanned by gdk-pixbuf-query-loaders in the first place
  def module_dir
    "#{HOMEBREW_PREFIX}/lib/gdk-pixbuf-#{gdk_so_ver}/#{gdk_module_ver}"
  end

  def post_install
    ENV["GDK_PIXBUF_MODULE_FILE"] = module_file
    ENV["GDK_PIXBUF_MODULEDIR"] = "#{module_dir}/loaders"
    system "#{bin}/gdk-pixbuf-query-loaders", "--update-cache"
    # Link newly created module_file into global gdk-pixbuf directory
    ln_sf module_file, module_dir
  end

  def caveats; <<-EOS.undent
    Programs that require this module need to set the environment variable
      export GDK_PIXBUF_MODULE_FILE="#{module_file}"
      export GDK_PIXBUF_MODULEDIR="#{module_dir}/loaders"
    If you need to manually update the query loader cache, set these variables then run
      #{bin}/gdk-pixbuf-query-loaders --update-cache
    EOS
  end if build.with?("relocations") || HOMEBREW_PREFIX.to_s != "/usr/local"

  test do
    system bin/"gdk-pixbuf-csource", test_fixtures("test.png")
  end
end
