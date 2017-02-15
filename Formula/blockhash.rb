class Blockhash < Formula
  desc "Perceptual image hash calculation tool"
  homepage "http://blockhash.io/"
  url "https://github.com/commonsmachinery/blockhash/archive/0.2.1.tar.gz"
  sha256 "549e0f52e7a7545bae7eca801c64c79b95cbe9417975718e262fddaf78b00cca"
  revision 1
  head "https://github.com/commonsmachinery/blockhash.git"

  bottle do
    cellar :any
    sha256 "3c3ba24b64ae845dd8ae24d3e6bd269786fcfb39261ac36a402193109a65241e" => :sierra
    sha256 "fafedb68fbf6cfb920f4dd67ce87dc364ce4a68c459101a9c85f7b01fc3a8dd4" => :el_capitan
    sha256 "6aa8c1b762feaa0299219b1bac86fec27261a8c92e9e9968fff4d3a2743fbdda" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "imagemagick"

  resource "testdata" do
    url "https://raw.githubusercontent.com/commonsmachinery/blockhash/ce08b465b658c4e886d49ec33361cee767f86db6/testdata/clipper_ship.jpg"
    sha256 "a9f6858876adadc83c8551b664632a9cf669c2aea4fec0c09d81171cc3b8a97f"
  end

  def install
    system "./waf", "configure", "--prefix=#{prefix}"
    system "./waf"
    system "./waf", "install"
  end

  test do
    resource("testdata").stage testpath
    hash = "00007ff07fe07fe07fe67ff07520600077fe601e7f5e000079fd40410001fffe"
    result = shell_output("#{bin}/blockhash #{testpath}/clipper_ship.jpg")
    assert_match hash, result
  end
end
