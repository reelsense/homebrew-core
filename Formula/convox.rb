class Convox < Formula
  desc "The convox AWS PaaS CLI tool"
  homepage "https://convox.com/"
  url "https://github.com/convox/rack/archive/20170606013346.tar.gz"
  sha256 "8556661668f961b48925dce6467ac30b68e892ec4521d0ffa618f865bdb7b5a5"

  bottle do
    cellar :any_skip_relocation
    sha256 "b4ed187365f31849d9d97d9166f78af4a26951cd3c76cf07bfb64768dce5e6ed" => :sierra
    sha256 "5e4a5528bcf788a4e92654966b56637e6c6dc0ff390e59de71ab2e22cba2e99e" => :el_capitan
    sha256 "5661d0b219b47e6958a5a92367e8af72e230efa4325bc7fba82ce2d939c6e1c8" => :yosemite
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
