require "yaml"

class KubeAws < Formula
  desc "CoreOS Kubernetes on AWS"
  homepage "https://coreos.com/kubernetes/docs/latest/kubernetes-on-aws.html"
  url "https://github.com/coreos/coreos-kubernetes/archive/v0.8.2.tar.gz"
  sha256 "85125641fca7431d8844192a22fb981dbd3de9c568aff2a7638812bf30f26d22"
  head "https://github.com/coreos/coreos-kubernetes.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b9423ac76c7163cf9b6810740ba27ac12f43a2281b946fb84f8ac51aea5bff72" => :sierra
    sha256 "05a8a4f3a52cf8be2ddb703fc6538528cbcc8c545666347f1f2cb54672db1d1e" => :el_capitan
    sha256 "5f66d7addd9e2c71a625e90083c88c9070cc76e16b2864f19c61c7b0ea3227eb" => :yosemite
  end

  depends_on "go" => :build

  def install
    gopath_vendor = buildpath/"_gopath-vendor"
    gopath_kube_aws = buildpath/"_gopath-kube-aws"
    kube_aws_dir = "#{gopath_kube_aws}/src/github.com/coreos/coreos-kubernetes/multi-node/aws"

    mkdir_p gopath_vendor
    mkdir_p File.dirname(kube_aws_dir)

    ln_s buildpath/"multi-node/aws/vendor", "#{gopath_vendor}/src"
    ln_s buildpath/"multi-node/aws", kube_aws_dir

    ENV["GOPATH"] = "#{gopath_vendor}:#{gopath_kube_aws}"

    cd kube_aws_dir do
      system "go", "generate", "./pkg/config"
      system "go", "build", "-ldflags",
             "-X github.com/coreos/coreos-kubernetes/multi-node/aws/pkg/cluster.VERSION=#{version}",
             "-a", "-tags", "netgo", "-installsuffix", "netgo",
             "-o", bin/"kube-aws", "./cmd/kube-aws"
    end
  end

  test do
    system "#{bin}/kube-aws"

    cluster = { "clusterName" => "test-cluster", "externalDNSName" => "dns",
                "keyName" => "key", "region" => "west",
                "availabilityZone" => "zone", "kmsKeyArn" => "arn" }
    system "#{bin}/kube-aws", "init", "--cluster-name", "test-cluster",
           "--external-dns-name", "dns", "--region", "west",
           "--availability-zone", "zone", "--key-name", "key",
           "--kms-key-arn", "arn"
    cluster_yaml = YAML.load_file("cluster.yaml")
    assert_equal cluster, cluster_yaml

    installed_version = shell_output("#{bin}/kube-aws version 2>&1")
    assert_match "kube-aws version #{version}", installed_version
  end
end
