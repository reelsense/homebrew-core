class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://github.com/fonttools/fonttools/releases/download/3.15.1/fonttools-3.15.1.zip"
  sha256 "8df4b605a28e313f0f9e0a79502caba4150a521347fdbafc063e52fee34912c2"
  head "https://github.com/fonttools/fonttools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "21823f14b416bbdb52733f62b8e6365a70222704c01deb041563d4e9e25199fa" => :sierra
    sha256 "5adcf8fd9bb7f3927c864df2f8046199d8d8b93f041882635a7e50275db7bdb1" => :el_capitan
    sha256 "d0e924db392775237fcfcc80f943a2e6d792876f981dd3907ef76c9f00862b36" => :yosemite
  end

  option "with-pygtk", "Build with pygtk support for pyftinspect"

  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "pygtk" => :optional

  def install
    virtualenv_install_with_resources
  end

  test do
    cp "/Library/Fonts/Arial.ttf", testpath
    system bin/"ttx", "Arial.ttf"
  end
end
