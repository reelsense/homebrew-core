class Convox < Formula
  desc "Command-line interface for the Rack PaaS on AWS"
  homepage "https://convox.com/"
  url "https://github.com/convox/rack/archive/20170807174226.tar.gz"
  sha256 "bcd2996562a88cebff04f7c0272a8953ba46d2b142304a3a7da91e9de9c6ae8c"

  bottle do
    cellar :any_skip_relocation
    sha256 "7f121f6419e5b0d3d4641ecd027cd6901d71348cb8f8e25c8b1ef488d4c0c6af" => :sierra
    sha256 "fcf7d8bab6bb30d5b7babd6c31f13e3be306803d7c4b9c9be28f29376e8066d2" => :el_capitan
    sha256 "a2d0f6aef543ab7e26e7823252b2b6743167bcdf1ae47098d75ea9dd45b1a3ff" => :yosemite
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
