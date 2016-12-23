class Direnv < Formula
  desc "Load/unload environment variables based on $PWD"
  homepage "https://direnv.net/"
  url "https://github.com/direnv/direnv/archive/v2.10.0.tar.gz"
  sha256 "0eb3a45b01dafa0d5fb9809c699820494168b74b5b723974af3370fa80e5bec0"

  head "https://github.com/direnv/direnv.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "bda608c2c50fc15f65215b74d25346dbd3ef7bd8f0f304a457f00cffeb89e587" => :sierra
    sha256 "9bd43f88fb0d8e660369671cc7f05a90235f959b9c971dab4f73f3fd53908b8f" => :el_capitan
    sha256 "610127d60ea04aef1e3eba1501a4c80e285d1c0009add32f1f5e4d9ada1d3b2b" => :yosemite
  end

  depends_on "go" => :build

  def install
    system "make", "install", "DESTDIR=#{prefix}"
  end

  test do
    system bin/"direnv", "status"
  end
end
