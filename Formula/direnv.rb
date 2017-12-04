class Direnv < Formula
  desc "Load/unload environment variables based on $PWD"
  homepage "https://direnv.net/"
  url "https://github.com/direnv/direnv/archive/v2.13.3.tar.gz"
  sha256 "2d5569ef08a919e02d8b229b8f71ca01a0f3920e7e14f0b10c0df76bb4ea57a1"
  head "https://github.com/direnv/direnv.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f4a160d40a7b3101624b5e044f0bf36a54b7b1b5230a821928fd301c4c0587d7" => :high_sierra
    sha256 "6cd30e08361f9b16089c50c311cfcf524d665964792cc808eae4b16320f57c65" => :sierra
    sha256 "40196ac96336929fd706e17936cd04d66dc1547144ce165a85d3ad51193a6fef" => :el_capitan
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/direnv/direnv").install buildpath.children
    cd "src/github.com/direnv/direnv" do
      system "make", "install", "DESTDIR=#{prefix}"
      prefix.install_metafiles
    end
  end

  test do
    system bin/"direnv", "status"
  end
end
