class Vapoursynth < Formula
  include Language::Python::Virtualenv

  desc "Video processing framework with simplicity in mind"
  homepage "http://www.vapoursynth.com"
  url "https://github.com/vapoursynth/vapoursynth/archive/R36.tar.gz"
  sha256 "8a156c5143cecd70b48e59428ec175e901510593082d3ddbc16fba93f5b6c704"
  head "https://github.com/vapoursynth/vapoursynth.git"

  bottle do
    sha256 "cce9f980ae99e67f68ed75efa2b3a4e851ca1b026ae6fc8355c7dddc06f5af6c" => :sierra
    sha256 "adf4f4e27f80b2136977b60c1cbde1305912b982fe2bfcd197e423e066076db1" => :el_capitan
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "yasm" => :build

  depends_on "libass"
  depends_on :macos => :el_capitan # due to zimg dependency
  depends_on :python3
  depends_on "tesseract"
  depends_on "zimg"

  resource "Cython" do
    url "https://files.pythonhosted.org/packages/2f/ae/0bb6ca970b949d97ca622641532d4a26395322172adaf645149ebef664eb/Cython-0.25.1.tar.gz"
    sha256 "e0941455769335ec5afb17dee36dc3833b7edc2ae20a8ed5806c58215e4b6669"
  end

  def install
    venv = virtualenv_create(buildpath/"cython", "python3")
    venv.pip_install "Cython"
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}",
                          "--with-cython=#{buildpath}/cython/bin/cython"
    system "make", "install"
  end

  test do
    system bin/"vspipe", "--version"
    system "python3", "-c", "import vapoursynth"
  end
end
