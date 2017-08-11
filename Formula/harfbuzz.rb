class Harfbuzz < Formula
  desc "OpenType text shaping engine"
  homepage "https://wiki.freedesktop.org/www/Software/HarfBuzz/"
  url "https://www.freedesktop.org/software/harfbuzz/release/harfbuzz-1.4.8.tar.bz2"
  sha256 "ccec4930ff0bb2d0c40aee203075447954b64a8c2695202413cc5e428c907131"

  bottle do
    sha256 "b8718336276a808df0bc6f7304fa141d806561a63f7e4fe55e40a5e817ab9fae" => :sierra
    sha256 "0aa772ec870adabd8d4ab32e0a320890b5342ea9eea30d9e92762767aad62364" => :el_capitan
    sha256 "44223a941491679f12df431cbbb122a5877e48f66e2587e785ba53716f55e139" => :yosemite
  end

  head do
    url "https://github.com/behdad/harfbuzz.git"

    depends_on "ragel" => :build
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  option "with-cairo", "Build command-line utilities that depend on Cairo"

  depends_on "pkg-config" => :build
  depends_on "freetype" => :recommended
  depends_on "glib" => :recommended
  depends_on "gobject-introspection" => :recommended
  depends_on "graphite2" => :recommended
  depends_on "icu4c" => :recommended
  depends_on "cairo" => :optional

  resource "ttf" do
    url "https://github.com/behdad/harfbuzz/raw/fc0daafab0336b847ac14682e581a8838f36a0bf/test/shaping/fonts/sha1sum/270b89df543a7e48e206a2d830c0e10e5265c630.ttf"
    sha256 "9535d35dab9e002963eef56757c46881f6b3d3b27db24eefcc80929781856c77"
  end

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --with-coretext=yes
      --enable-static
    ]

    if build.with? "cairo"
      args << "--with-cairo=yes"
    else
      args << "--with-cairo=no"
    end

    if build.with? "freetype"
      args << "--with-freetype=yes"
    else
      args << "--with-freetype=no"
    end

    if build.with? "glib"
      args << "--with-glib=yes"
    else
      args << "--with-glib=no"
    end

    if build.with? "gobject-introspection"
      args << "--with-gobject=yes" << "--enable-introspection=yes"
    else
      args << "--with-gobject=no" << "--enable-introspection=no"
    end

    if build.with? "graphite2"
      args << "--with-graphite2=yes"
    else
      args << "--with-graphite2=no"
    end

    if build.with? "icu4c"
      args << "--with-icu=yes"
    else
      args << "--with-icu=no"
    end

    system "./autogen.sh" if build.head?
    system "./configure", *args
    system "make", "install"
  end

  test do
    resource("ttf").stage do
      shape = `echo 'സ്റ്റ്' | #{bin}/hb-shape 270b89df543a7e48e206a2d830c0e10e5265c630.ttf`.chomp
      assert_equal "[glyph201=0+1183|U0D4D=0+0]", shape
    end
  end
end
