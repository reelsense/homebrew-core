class Convox < Formula
  desc "The convox AWS PaaS CLI tool"
  homepage "https://convox.com/"
  url "https://github.com/convox/rack/archive/20170417130911.tar.gz"
  sha256 "8ec3047eb69b4bd141c9a858dbb7f971750a3b0fbea057864a860f66dd38e7c8"

  bottle do
    cellar :any_skip_relocation
    sha256 "cf6e57bf459bc60568731db6a3e0b50a9414e952c7d3d6ed52196fd1dba25ec5" => :sierra
    sha256 "85f28250c6409d819255c41395c56e44722f6fe26c59e6b8121ced703a707027" => :el_capitan
    sha256 "55da5cf79e5a0f67bd84a254da6798b680c1c57f62666b1b7104153d5c65c678" => :yosemite
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
