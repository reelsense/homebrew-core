class KubernetesCli < Formula
  desc "Kubernetes command-line interface"
  homepage "http://kubernetes.io/"
  url "https://github.com/kubernetes/kubernetes/archive/v1.4.4.tar.gz"
  sha256 "ab6304dbff6e49095d68459da748477ffba231893e1f1dae4e0d60ba2fdb725a"
  head "https://github.com/kubernetes/kubernetes.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "712e3053d4a42de5dd3db6525b3e983bfcb86f8e59683ed4d3eb74e6680ead2d" => :sierra
    sha256 "291244881a405da8ea4098ecf83bb26a053f12aa473e17ff685aadc2c1ceee69" => :el_capitan
    sha256 "c4358945926ea4224a7412afcca5a9eecb045c3b3aa1f1507ab58c30d6e48fdf" => :yosemite
  end

  devel do
    url "https://github.com/kubernetes/kubernetes/archive/v1.5.0-alpha.1.tar.gz"
    sha256 "4b05aa319c394e085c219ab8f7b2170ee137da2f726da51d8acda450e67ceb00"
    version "1.5.0-alpha.1"
  end

  depends_on "go" => :build

  def install
    # Patch needed to avoid vendor dependency on github.com/jteeuwen/go-bindata
    # Build will otherwise fail with missing dep
    # Raised in https://github.com/kubernetes/kubernetes/issues/34067
    rm "./test/e2e/framework/gobindata_util.go"

    # Race condition still exists in OSX Yosemite
    # Filed issue: https://github.com/kubernetes/kubernetes/issues/34635
    ENV.deparallelize { system "make", "generated_files" }
    system "make", "kubectl", "GOFLAGS=-v"

    arch = MacOS.prefer_64_bit? ? "amd64" : "x86"
    bin.install "_output/local/bin/darwin/#{arch}/kubectl"

    output = Utils.popen_read("#{bin}/kubectl completion bash")
    (bash_completion/"kubectl").write output
  end

  test do
    output = shell_output("#{bin}/kubectl 2>&1")
    assert_match "kubectl controls the Kubernetes cluster manager.", output
  end
end
