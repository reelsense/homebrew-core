require "language/go"

class Gauge < Formula
  desc "Test automation tool that supports executable documentation"
  homepage "https://getgauge.io"
  url "https://github.com/getgauge/gauge/archive/v0.9.1.tar.gz"
  sha256 "659cd9679fa258ec142cf80ed92282c41aac44152f1193fa804bf00550e64e3a"
  head "https://github.com/getgauge/gauge.git"

  bottle do
    sha256 "549961642f91a13ddeecb54e42fc29082a2caded0899db94322b94cf65044b56" => :high_sierra
    sha256 "4ca860842b71c958face93d07452cae6ccc220ec50914123e7775b77e6b286f6" => :sierra
    sha256 "0e7d6e4108eab026d9fcd9905fce65c159146bdf903f516c5499a2b52ede18d2" => :el_capitan
    sha256 "15cfbf4804217e796de1d7508bdcd28b54130b69e5fa791ddef9eb04f243c770" => :yosemite
  end

  depends_on "go" => :build
  depends_on "godep" => :build

  go_resource "github.com/getgauge/gauge_screenshot" do
    url "https://github.com/getgauge/gauge_screenshot.git",
        :revision => "f16bcf089e263db525a255c9f9621ca0270ff1d3"
  end

  def install
    ENV["GOPATH"] = buildpath
    ENV["GOROOT"] = Formula["go"].opt_libexec

    # Avoid executing `go get`
    inreplace "build/make.go", /\tgetGaugeScreenshot\(\)\n/, ""

    dir = buildpath/"src/github.com/getgauge/gauge"
    dir.install buildpath.children
    ln_s buildpath/"src", dir

    Language::Go.stage_deps resources, buildpath/"src"
    ln_s "gauge_screenshot", "src/github.com/getgauge/screenshot"

    cd dir do
      system "godep", "restore"
      system "go", "run", "build/make.go"
      system "go", "run", "build/make.go", "--install", "--prefix", prefix
    end
  end

  test do
    assert_match version.to_s[0, 5], shell_output("#{bin}/gauge -v")
  end
end
