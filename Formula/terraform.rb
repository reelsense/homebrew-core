require "language/go"

class Terraform < Formula
  desc "Tool to build, change, and version infrastructure"
  homepage "https://www.terraform.io/"
  url "https://github.com/hashicorp/terraform/archive/v0.8.4.tar.gz"
  sha256 "71e93503614f073f00eb65b1379ac6b80ea8a881998490a016af15208853be73"
  head "https://github.com/hashicorp/terraform.git"

  bottle do
    sha256 "e1a862010f45c40579c60824d44e363a8e6dafec1133621ff17001ec242edb69" => :sierra
    sha256 "e39368674d9ae7c8ced56afdb2c9272ace52b5ead3eed14fc7641a0dce066d6f" => :el_capitan
    sha256 "bb9f76ff821920f745f5f7c0fc4e82718d68f5f64e3ca91a3def83158d70a65b" => :yosemite
  end

  depends_on "go" => :build

  go_resource "github.com/mitchellh/gox" do
    url "https://github.com/mitchellh/gox.git",
        :revision => "c9740af9c6574448fd48eb30a71f964014c7a837"
  end

  go_resource "github.com/mitchellh/iochan" do
    url "https://github.com/mitchellh/iochan.git",
        :revision => "87b45ffd0e9581375c491fef3d32130bb15c5bd7"
  end

  go_resource "github.com/kisielk/errcheck" do
    url "https://github.com/kisielk/errcheck.git",
        :revision => "9c1292e1c962175f76516859f4a88aabd86dc495"
  end

  go_resource "github.com/kisielk/gotool" do
    url "https://github.com/kisielk/gotool.git",
        :revision => "5e136deb9b893bbe6c8f23236ff4378b7a8a0dbb"
  end

  go_resource "golang.org/x/tools" do
    url "https://go.googlesource.com/tools.git",
        :revision => "26c35b4dcf6dfcb924e26828ed9f4d028c5ce05a"
  end

  def install
    ENV["GOPATH"] = buildpath
    # For the gox buildtool used by terraform, which doesn't need to
    # get installed permanently
    ENV.append_path "PATH", buildpath

    terrapath = buildpath/"src/github.com/hashicorp/terraform"
    terrapath.install Dir["*"]
    Language::Go.stage_deps resources, buildpath/"src"

    cd "src/github.com/mitchellh/gox" do
      system "go", "build"
      buildpath.install "gox"
    end

    cd "src/golang.org/x/tools/cmd/stringer" do
      ENV.deparallelize { system "go", "build" }
      buildpath.install "stringer"
    end

    cd "src/github.com/kisielk/errcheck" do
      system "go", "build"
      buildpath.install "errcheck"
    end

    cd terrapath do
      # v0.6.12 - source contains tests which fail if these environment variables are set locally.
      ENV.delete "AWS_ACCESS_KEY"
      ENV.delete "AWS_SECRET_KEY"

      # Runs format check and test suite via makefile
      ENV.deparallelize { system "make", "test", "vet" }

      # Generate release binary
      arch = MacOS.prefer_64_bit? ? "amd64" : "386"
      ENV["XC_OS"] = "darwin"
      ENV["XC_ARCH"] = arch
      system "make", "bin"

      # Install release binary
      bin.install "pkg/darwin_#{arch}/terraform"
      zsh_completion.install "contrib/zsh-completion/_terraform"
    end
  end

  test do
    minimal = testpath/"minimal.tf"
    minimal.write <<-EOS.undent
      variable "aws_region" {
          default = "us-west-2"
      }

      variable "aws_amis" {
          default = {
              eu-west-1 = "ami-b1cf19c6"
              us-east-1 = "ami-de7ab6b6"
              us-west-1 = "ami-3f75767a"
              us-west-2 = "ami-21f78e11"
          }
      }

      # Specify the provider and access details
      provider "aws" {
          access_key = "this_is_a_fake_access"
          secret_key = "this_is_a_fake_secret"
          region = "${var.aws_region}"
      }

      resource "aws_instance" "web" {
        instance_type = "m1.small"
        ami = "${lookup(var.aws_amis, var.aws_region)}"
        count = 4
      }
    EOS
    system "#{bin}/terraform", "graph", testpath
  end
end
