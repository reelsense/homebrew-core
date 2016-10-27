require "yaml"

class KubeAws < Formula
  desc "CoreOS Kubernetes on AWS"
  homepage "https://coreos.com/kubernetes/docs/latest/kubernetes-on-aws.html"
  url "https://github.com/coreos/coreos-kubernetes/archive/v0.8.3.tar.gz"
  sha256 "549e5c572fb8842b777d839a8aebadb4165aa5e3d8f4887e87a64347cb6ece09"
  head "https://github.com/coreos/coreos-kubernetes.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e435ef5fa8b83a63334fcadb5d432eabf85fac6e055926ddb8848f27fc3da7d5" => :sierra
    sha256 "79af2b3afdb2adaeb0538aa702bd7bff555b0c4b55140bfd3cc7440bca0a36f2" => :el_capitan
    sha256 "6c5d8d12c01d94918ef68bf4d487aa1b6f577bed3aa64145cd58192fdb8aa948" => :yosemite
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
