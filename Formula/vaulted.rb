require "language/go"

class Vaulted < Formula
  desc "Allows the secure storage and execution of environments"
  homepage "https://github.com/miquella/vaulted"
  url "https://github.com/miquella/vaulted/archive/v2.1.1.tar.gz"
  sha256 "e8adc5d8b2e6b1ad264c851aa864bdd57359b0024a5768de5f1231e3ae5f644c"

  head "https://github.com/miquella/vaulted.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c3e5997ac5d059daa21e70a20a81ae1ac921fb1a5d52686884e1dee0cd8f0061" => :sierra
    sha256 "4e4afb85b441e944f731280761ded36de02cf27cff2a13d7e461483a453559ef" => :el_capitan
    sha256 "d7c2bc58bdabf6ada0730ac1b90d3f08c9aaa3754b7070e17873b11445e63f7d" => :yosemite
  end

  depends_on "go" => :build

  go_resource "github.com/aws/aws-sdk-go" do
    url "https://github.com/aws/aws-sdk-go.git",
        :revision => "baba9e786eae5ba978f2007f8e718557b29157c8"
  end

  go_resource "github.com/chzyer/readline" do
    url "https://github.com/chzyer/readline.git",
        :revision => "41eea22f717c616615e1e59aa06cf831f9901f35"
  end

  go_resource "github.com/fatih/color" do
    url "https://github.com/fatih/color.git",
        :revision => "9131ab34cf20d2f6d83fdc67168a5430d1c7dc23"
  end

  go_resource "github.com/miquella/ask" do
    url "https://github.com/miquella/ask.git",
        :revision => "486a722fa4cdb033d35a501d54116b645e139ef3"
  end

  go_resource "github.com/miquella/xdg" do
    url "https://github.com/miquella/xdg.git",
        :revision => "1ee6df0d556245ee71d26d54f9dbfea1f84d136a"
  end

  go_resource "github.com/spf13/pflag" do
    url "https://github.com/spf13/pflag.git",
        :revision => "2300d0f8576fe575f71aaa5b9bbe4e1b0dc2eb51"
  end

  go_resource "golang.org/x/crypto" do
    url "https://go.googlesource.com/crypto.git",
        :revision => "efac7f277b17c19894091e358c6130cb6bd51117"
  end

  def install
    ENV["GOPATH"] = buildpath
    mkdir_p buildpath/"src/github.com/miquella"
    ln_s buildpath, "src/github.com/miquella/vaulted"
    Language::Go.stage_deps resources, buildpath/"src"

    system "go", "build", "-o", bin/"vaulted", "github.com/miquella/vaulted"
    man1.install Dir["doc/man/vaulted*.1"]
  end

  test do
    (testpath/".local/share/vaulted").mkpath
    touch(".local/share/vaulted/test_vault")
    output = IO.popen(["#{bin}/vaulted", "ls"], &:read)
    output == "test_vault\n"
  end
end
