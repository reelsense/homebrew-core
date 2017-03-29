class Convox < Formula
  desc "The convox AWS PaaS CLI tool"
  homepage "https://convox.com/"
  url "https://github.com/convox/rack/archive/20170327214533.tar.gz"
  sha256 "d1839674530663b4982958c69d8fad55b038558a375593a3bac0ba7bf28e665c"

  bottle do
    cellar :any_skip_relocation
    sha256 "6cf6e1e73a1c9c293aeda676fa42ff9f2873c4f67cdee1e7d7849ed81807c350" => :sierra
    sha256 "dea3a7e1036683a9a5ddeb18421d441fcf438485e8b58d744d3edebeb84cf5d4" => :el_capitan
    sha256 "9eda9ec23034e561d7e9bbc647d4fc0a736ccf72a89b70cbf9868f39aeeb10f4" => :yosemite
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
