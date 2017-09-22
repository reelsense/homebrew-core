class Kompose < Formula
  desc "Tool to move from `docker-compose` to Kubernetes"
  homepage "http://kompose.io"
  url "https://github.com/kubernetes/kompose/archive/v1.2.0.tar.gz"
  sha256 "9fb15d30c6e33025237801f401d6b57b164a142f205d48b1574edf1f9aa92434"

  bottle do
    cellar :any_skip_relocation
    sha256 "04e2cca9ffd595e926ed3a386e348ba58bc606e9a54d4bf013992ddecfacd4d0" => :high_sierra
    sha256 "6c1f0fc6d0b821719d8ebb3b2447c969512c176b5878f9a7df32333547ea8d7a" => :sierra
    sha256 "ae9f5cdbdc636d6f0f9e1afda5fccab2d0ff0054b07654657581f6c6d71e8597" => :el_capitan
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    mkdir_p buildpath/"src/github.com/kubernetes"
    ln_s buildpath, buildpath/"src/github.com/kubernetes/kompose"
    system "make", "bin"
    bin.install "kompose"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kompose version")
  end
end
