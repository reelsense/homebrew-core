class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://github.com/fonttools/fonttools/releases/download/3.19.0/fonttools-3.19.0.zip"
  sha256 "8d1dcb1ff3665b69e52d020590e20c460445b7d80b5cb573832cf97ec97c74af"
  head "https://github.com/fonttools/fonttools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "83d6c9b755887ee7a65483c31431e859e74ff1ce1fcb0f5e36be420371f784aa" => :high_sierra
    sha256 "f808975b1920bb1da2e9fe1166fc5502d42ca094b77deedfef22e5b68c1194ba" => :sierra
    sha256 "51c4922da3dfdb44083ef8942aef8266e1b5f9290b94ba413896d50c01ce6159" => :el_capitan
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
