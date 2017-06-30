class Glibmm < Formula
  desc "C++ interface to glib"
  homepage "https://www.gtkmm.org/"
  url "https://download.gnome.org/sources/glibmm/2.52/glibmm-2.52.0.tar.xz"
  sha256 "81b8abf21c645868c06779abc5f34efc1a51d5e61589dab2a2ed67faa8d4811e"

  bottle do
    cellar :any
    sha256 "164c9ffdb884bedd6f9a5bab6da8a9cad34eaac38e1fa03947290fc458d24837" => :sierra
    sha256 "a83afbac89c62793d5e1fa23fc4cca036bcffe70e0c60dc4691e27e5574ee1ab" => :el_capitan
    sha256 "763bf6f5b5ef1817b3a0458114ce871d3a582806ea225ef329b9673407bd817b" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "libsigc++"
  depends_on "glib"

  needs :cxx11

  def install
    ENV.cxx11

    # see https://bugzilla.gnome.org/show_bug.cgi?id=781947
    inreplace "gio/giomm/Makefile.in" do |s|
      s.gsub! "OS_COCOA_TRUE", "OS_COCOA_TEMP"
      s.gsub! "OS_COCOA_FALSE", "OS_COCOA_TRUE"
      s.gsub! "OS_COCOA_TEMP", "OS_COCOA_FALSE"
    end

    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <glibmm.h>

      int main(int argc, char *argv[])
      {
         Glib::ustring my_string("testing");
         return 0;
      }
    EOS
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    libsigcxx = Formula["libsigc++"]
    flags = %W[
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{include}/glibmm-2.4
      -I#{libsigcxx.opt_include}/sigc++-2.0
      -I#{libsigcxx.opt_lib}/sigc++-2.0/include
      -I#{lib}/glibmm-2.4/include
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{libsigcxx.opt_lib}
      -L#{lib}
      -lglib-2.0
      -lglibmm-2.4
      -lgobject-2.0
      -lintl
      -lsigc-2.0
    ]
    system ENV.cxx, "-std=c++11", "test.cpp", "-o", "test", *flags
    system "./test"
  end
end
