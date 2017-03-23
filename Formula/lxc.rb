class Lxc < Formula
  desc "CLI client for interacting with LXD"
  homepage "https://linuxcontainers.org"
  url "https://linuxcontainers.org/downloads/lxd/lxd-2.12.tar.gz"
  sha256 "439bdadc7c63c523999a8d26b274a5c1c397d897197b43df8ce4b225a75585ff"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "475623b884587fcd3ef752e2c124f36a7e66d9fd59328071f44dd3875e2e38bc" => :sierra
    sha256 "10bcfb2fd37c10bef2e50d83f3728abccbd3a5f8415a788d21151ca2a555c6cd" => :el_capitan
    sha256 "8f10473aebd224e27fd9c1631a0c9d734623bb13fa0db6f507e4e09b71be5d8f" => :yosemite
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GOBIN"] = bin

    ln_s buildpath/"dist/src", buildpath/"src"
    system "go", "install", "-v", "github.com/lxc/lxd/lxc"
  end

  test do
    system "#{bin}/lxc", "--version"
  end
end
