class Geckodriver < Formula
  desc "WebDriver <-> Marionette proxy"
  homepage "https://github.com/mozilla/geckodriver"
  url "https://github.com/mozilla/geckodriver/archive/v0.14.0.tar.gz"
  sha256 "d9a5d240895ee11ff2034cfcaad1bc2e83169e2c9700913485546c452e3d57ee"

  bottle do
    sha256 "6e7521051120fd647e9445722b7f49f55459527c4398f8c7767ed411c34ed107" => :sierra
    sha256 "0291e5251836f29e8ef67fa8aecb2aa3d81b9327b7eeb030f1781e0e6ef2d82d" => :el_capitan
    sha256 "5cd25abbf348da927e9b772a702ee4d11e4629d2e98d93480f5215a599b66038" => :yosemite
  end

  depends_on "rust" => :build

  def install
    system "cargo", "build"
    bin.install "target/debug/geckodriver"
    bin.install_symlink bin/"geckodriver" => "wires"
  end

  test do
    system bin/"geckodriver", "--help"
  end
end
