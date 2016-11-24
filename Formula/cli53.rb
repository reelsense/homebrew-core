class Cli53 < Formula
  desc "command-line tool for Amazon Route 53"
  homepage "https://github.com/barnybug/cli53"
  url "https://github.com/barnybug/cli53/archive/0.8.7.tar.gz"
  sha256 "c05918a1c1e5e660bda4b6ca080234a5ccc7c02d8c5b5f9f761faa57f53fb95c"

  bottle do
    cellar :any_skip_relocation
    sha256 "df1268d4c4416fa2f9837cbdfd2b06c49d679d95d027671426a4becc664fd643" => :sierra
    sha256 "1ae8290fb59ba09f22a384487302e895c5f42cab117e32cc4fc9acc4d8e85636" => :el_capitan
    sha256 "84ceef6568a1eabcbbcb08f5eb060c3dae4805f81fb9da6c088c31b61f42d7b4" => :yosemite
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    mkdir_p buildpath/"src/github.com/barnybug"
    ln_s buildpath, buildpath/"src/github.com/barnybug/cli53"

    system "make", "build"
    bin.install "cli53"
  end

  test do
    assert_match "list domains", shell_output("#{bin}/cli53 help list")
  end
end
