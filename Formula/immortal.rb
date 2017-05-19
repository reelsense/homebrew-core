require "language/go"

class Immortal < Formula
  desc "OS agnostic (*nix) cross-platform supervisor"
  homepage "https://immortal.run/"
  url "https://github.com/immortal/immortal/archive/0.13.3.tar.gz"
  sha256 "0d5646ae4d57d867b6178f2fb105ee4e8a1567580baea6683752cdc27cbb910f"
  head "https://github.com/immortal/immortal.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "7c17b3a8226613f09742e58d7daea1056c970ae6fa4fad592754902a7536cbd0" => :sierra
    sha256 "580bfe4ac95d243eab193534db466b22a20dd7c49893a2352d270710838eb110" => :el_capitan
    sha256 "14c19249ce050a37e30a9b4aac9128bba7248161e625e0b6b26e16285a9649db" => :yosemite
  end

  depends_on "go" => :build

  go_resource "github.com/go-yaml/yaml" do
    url "https://github.com/go-yaml/yaml.git",
        :revision => "cd8b52f8269e0feb286dfeef29f8fe4d5b397e0b"
  end

  go_resource "github.com/nbari/violetear" do
    url "https://github.com/nbari/violetear.git",
        :revision => "502d8b0480c0d356d94b16b22ad222deec81e6cc"
  end

  go_resource "github.com/immortal/logrotate" do
    url "https://github.com/immortal/logrotate.git",
        :revision => "3691ab555939319a80a8833983faedb8b76d9cc6"
  end

  go_resource "github.com/immortal/multiwriter" do
    url "https://github.com/immortal/multiwriter.git",
        :revision => "2555774a03ac1d12b5bb4392858959ee50f78884"
  end

  go_resource "github.com/immortal/natcasesort" do
    url "https://github.com/immortal/natcasesort.git",
        :revision => "69368b73881a69041466dd2b4fc0373f8e47db15"
  end

  go_resource "github.com/immortal/xtime" do
    url "https://github.com/immortal/xtime.git",
        :revision => "fb1aca1146ea82769e8433f5bb22f373765e7ecc"
  end

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/immortal/immortal").install buildpath.children
    Language::Go.stage_deps resources, buildpath/"src"
    cd "src/github.com/immortal/immortal" do
      ldflags = "-s -w -X main.version=#{version}"
      system "go", "build", "-ldflags", ldflags, "-o", "#{bin}/immortal", "cmd/immortal/main.go"
      system "go", "build", "-ldflags", ldflags, "-o", "#{bin}/immortalctl", "cmd/immortalctl/main.go"
      system "go", "build", "-ldflags", ldflags, "-o", "#{bin}/immortaldir", "cmd/immortaldir/main.go"
      man8.install Dir["man/*.8"]
    end
  end

  test do
    system bin/"immortal", "-v"
    system bin/"immortalctl", "-v"
    system bin/"immortaldir", "-v"
  end
end
