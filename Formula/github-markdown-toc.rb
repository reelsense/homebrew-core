class GithubMarkdownToc < Formula
  desc "Easy TOC creation for GitHub README.md (in go)"
  homepage "https://github.com/ekalinin/github-markdown-toc.go"
  url "https://github.com/ekalinin/github-markdown-toc.go/archive/0.7.1.tar.gz"
  sha256 "458032ba4e74a0c5284ae476e874986e0c6c96876faf414dac181e5b9d0217bb"

  bottle do
    cellar :any_skip_relocation
    sha256 "31bcbaa4a40b5a3a95809160797c8ea5e2f91ac292e401b04edebaec5772d128" => :sierra
    sha256 "cf2b7410f56f1cccf40e435c2200bb06e5e0d39ed593fa64d9ce18787db5da94" => :el_capitan
    sha256 "a0b6d40d755f2f7293fb86ba0b5d27aa1b1073e845ce6829a73c1bcd7c7c0ba2" => :yosemite
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    dir = buildpath/"src/github.com/ekalinin/github-markdown-toc.go"
    dir.install buildpath.children
    cd dir do
      system "go", "build", "-o", bin/"gh-md-toc", "main.go"
      prefix.install_metafiles
    end
  end

  test do
    system bin/"gh-md-toc", "--version"
    system bin/"gh-md-toc", "../README.md"
  end
end
