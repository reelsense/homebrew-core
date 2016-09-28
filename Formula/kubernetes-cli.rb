class KubernetesCli < Formula
  desc "Kubernetes command-line interface"
  homepage "http://kubernetes.io/"
  url "https://github.com/kubernetes/kubernetes/archive/v1.3.7.tar.gz"
  sha256 "40a655b5ae1734acfda157088a20853aaf87945508edf73497bec5fa26352a9b"
  head "https://github.com/kubernetes/kubernetes.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "8847676dee7de017eeccd753ef1a10871d437d2b84e1cdb2158923a088879dec" => :sierra
    sha256 "2cf1c6ef203ad6fb22ab3409b119d80c8d29f2705c6ffccd164da57b0b45793c" => :el_capitan
    sha256 "808c93e78b84f743877690d72aee24a61415af5fc1cc4c7bbd6c7b60fa66b735" => :yosemite
  end

  devel do
    # building from the tag lets it pick up the correct version info
    url "https://github.com/kubernetes/kubernetes.git",
        :tag => "v1.4.0-alpha.3",
        :revision => "b44b716965db2d54c8c7dfcdbcb1d54792ab8559"
    version "1.4.0-alpha.3"
  end

  depends_on "go" => :build

  def install
    if build.stable?
      system "make", "all", "WHAT=cmd/kubectl", "GOFLAGS=-v"
    else
      # avoids needing to vendor github.com/jteeuwen/go-bindata
      rm "./test/e2e/framework/gobindata_util.go"

      ENV.deparallelize { system "make", "generated_files" }
      system "make", "kubectl", "GOFLAGS=-v"
    end
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
