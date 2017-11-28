require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-1.5.4.tgz"
  sha256 "19a47f25774e060bed47faf7242490c7e067f15e2dff8a568c82b40eb5072e97"

  bottle do
    sha256 "4cc40b978db3a60f6201b7bd97551c5030556ed905dbed30cbe2486ee26d22b4" => :high_sierra
    sha256 "da30fa4803bcb7b9a3fd70900326a676fbee25f3fcb98aac3e90a46bd62220a0" => :sierra
    sha256 "02e03ab6dede4e097c79f6c87fee91f88c82260f137619489dc65b790728c91a" => :el_capitan
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"ng", "new", "--skip-install", "angular-homebrew-test"
    assert_predicate testpath/"angular-homebrew-test/package.json", :exist?, "Project was not created"
  end
end
