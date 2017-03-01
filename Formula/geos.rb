class Geos < Formula
  desc "Geometry Engine"
  homepage "https://trac.osgeo.org/geos"
  url "http://download.osgeo.org/geos/geos-3.6.1.tar.bz2"
  sha256 "4a2e4e3a7a09a7cfda3211d0f4a235d9fd3176ddf64bd8db14b4ead266189fc5"

  bottle do
    cellar :any
    sha256 "02aa28dcfd38747e924fa486b1607c90ddf5e18c7a400510e3d7f12ef6b90d86" => :sierra
    sha256 "b4f3fd82b0f39f109ff3da7d5027471c8c2bc8f39bc24198af145df9d3576a71" => :el_capitan
    sha256 "5b20acb4dfa59515be97f9f731f497c59d11deee2547ca61191b0da4eb8cf735" => :yosemite
  end

  option :cxx11
  option "with-php", "Build the PHP extension"
  option "without-python", "Do not build the Python extension"
  option "with-ruby", "Build the ruby extension"

  depends_on "swig" => :build if build.with?("python") || build.with?("ruby")

  def install
    ENV.cxx11 if build.cxx11?

    # https://trac.osgeo.org/geos/ticket/771
    inreplace "configure" do |s|
      s.gsub! /PYTHON_CPPFLAGS=.*/, %Q(PYTHON_CPPFLAGS="#{`python-config --includes`.strip}")
      s.gsub! /PYTHON_LDFLAGS=.*/, 'PYTHON_LDFLAGS="-Wl,-undefined,dynamic_lookup"'
    end

    args = [
      "--disable-dependency-tracking",
      "--prefix=#{prefix}",
    ]

    args << "--enable-php" if build.with?("php")
    args << "--enable-python" if build.with?("python")
    args << "--enable-ruby" if build.with?("ruby")

    system "./configure", *args
    system "make", "install"
  end

  test do
    system "#{bin}/geos-config", "--libs"
  end
end
