class Siril < Formula
  desc "Astronomical image processing tool"
  homepage "https://free-astro.org/index.php/Siril"
  url "https://free-astro.org/download/siril-0.9.8.tar.bz2"
  sha256 "ecb5477937afc02cc89cb07f4a7b99d2d0ab4cc5e715ec536e9be5c92a187170"
  head "https://free-astro.org/svn/siril/", :using => :svn

  bottle do
    sha256 "6d1f39ba2a4daab4e67f220e894f1f3ae3e3f36698b8c7df00a76aaa9bffadbc" => :high_sierra
    sha256 "686d08559fa130afc80de37b980b090689d730c699e958dbe619a648ecc1d582" => :sierra
    sha256 "e34d392a486720624f58b204931573222b10a0182b687e339b5aad9bce98258d" => :el_capitan
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "intltool" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "adwaita-icon-theme"
  depends_on "cfitsio"
  depends_on "ffms2"
  depends_on "fftw"
  depends_on "gcc" # for OpenMP
  depends_on "gnuplot"
  depends_on "gsl"
  depends_on "gtk-mac-integration"
  depends_on "libconfig"
  depends_on "libraw"
  depends_on "librsvg"
  depends_on "libsvg"
  depends_on "netpbm"
  depends_on "opencv"
  depends_on "openjpeg"

  fails_with :clang # no OpenMP support

  needs :cxx11

  def install
    ENV.cxx11

    system "./autogen.sh", "--prefix=#{prefix}", "--enable-openmp"
    system "make", "install"
  end

  test do
    system "#{bin}/siril", "-v"
  end
end
