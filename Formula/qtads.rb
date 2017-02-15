class Qtads < Formula
  desc "TADS multimedia interpreter"
  homepage "https://qtads.sourceforge.io/"
  head "https://github.com/realnc/qtads.git"

  stable do
    url "https://downloads.sourceforge.net/project/qtads/qtads-2.x/2.1.7/qtads-2.1.7.tar.bz2"
    sha256 "7477bb3cb1f74dcf7995a25579be8322c13f64fb02b7a6e3b2b95a36276ef231"

    # Remove for > 2.1.7
    # fix infinite recursion
    patch do
      url "https://github.com/realnc/qtads/commit/d22054b.patch"
      sha256 "10157fc4c03cf33496d93d18e5ca3c044df5457c7e56c454dabfb154ffb627ca"
    end

    # Remove for > 2.1.7
    # fix pointer/integer comparison
    patch do
      url "https://github.com/realnc/qtads/commit/46701a2.patch"
      sha256 "34aa02b5ef0ec4e61c47cbd64fd256d3ebe158925c69680a91208f71b77a52d1"
    end
  end

  bottle do
    cellar :any
    sha256 "39f13ab007d79d3ce020424a2a52f6eac223233a40907a3ce4ca8f74fe6c328d" => :sierra
    sha256 "39f13ab007d79d3ce020424a2a52f6eac223233a40907a3ce4ca8f74fe6c328d" => :el_capitan
    sha256 "943945d02fc1dad997f31f95d8a5d5dd37ebce4db98dcc9aa5e3fa74ebff895e" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "qt5"
  depends_on "sdl2"
  depends_on "sdl2_mixer"
  depends_on "sdl_sound"

  def install
    sdl_sound_include = Formula["sdl_sound"].opt_include
    inreplace "qtads.pro",
      "INCLUDEPATH += src $$T2DIR $$T3DIR $$HTDIR",
      "INCLUDEPATH += src $$T2DIR $$T3DIR $$HTDIR #{sdl_sound_include}/SDL"

    system "qmake", "DEFINES+=NO_STATIC_TEXTCODEC_PLUGINS"
    system "make"
    prefix.install "QTads.app"
    bin.write_exec_script "#{prefix}/QTads.app/Contents/MacOS/QTads"
    man6.install "share/man/man6/qtads.6"
  end

  test do
    assert File.exist?("#{bin}/QTads"), "I'm an untestable GUI app."
  end
end
