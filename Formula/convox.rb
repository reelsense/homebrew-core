class Convox < Formula
  desc "Command-line interface for the Rack PaaS on AWS"
  homepage "https://convox.com/"
  url "https://github.com/convox/rack/archive/20170925221816.tar.gz"
  sha256 "557d700c34dce238eb263fe0ea1970cc9a639d0146a092a4dfa2bcf2f8b56304"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "aec53819727cdf8319bf7d3a8ac1e905b4c55198907d9196a0b7530a4746e5dd" => :high_sierra
    sha256 "7cb97c64fbba7718e1f76e20b7b1345dd8eda1c036061c89fdaa855f5808070b" => :sierra
    sha256 "e8d9e4945406ab1db48fe0048f18d7aaa0c3a80db972a345b38fdf5d0f1bdc57" => :el_capitan
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
