class Convox < Formula
  desc "The convox AWS PaaS CLI tool"
  homepage "https://convox.com/"
  url "https://github.com/convox/rack/archive/20170508213441.tar.gz"
  sha256 "74860e3aff62449c0398c3c01cfd448857be35fd8bea4286ce657494331047d8"

  bottle do
    cellar :any_skip_relocation
    sha256 "3794f3cc0db1f4e73d4e6da8bde8828e3d191dd965a2f525203795aedf1ba4e5" => :sierra
    sha256 "04c5bbd47e64971a15f9aaab75459504ccc34036fea34a9256fa03e46c11ae7a" => :el_capitan
    sha256 "80e7b536ef953031707842e703f588e230e644226a54d9cabb5ad18fb4f9d210" => :yosemite
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/convox/rack").install Dir["*"]
    system "go", "build", "-ldflags=-X main.Version=#{version}",
           "-o", bin/"convox", "-v", "github.com/convox/rack/cmd/convox"
  end

  test do
    system bin/"convox"
  end
end
