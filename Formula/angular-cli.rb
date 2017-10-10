require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-1.4.5.tgz"
  sha256 "1c400473cd08e80cbf9912fe0b4c62a86f72a617f48e40865361c2160d8432f7"

  bottle do
    sha256 "f0bc7a5e645e7de7a3ace5daf00d91c3f86938be7f0d841e5e70a4998cbcd07c" => :high_sierra
    sha256 "003be433c86bea6e2bca892c6ab8ecf057cb70c3576bdb1e5a1cd3728a28c127" => :sierra
    sha256 "6fc49f468f0af149850cb0a88a84582aa5282aed026e941edbc2bfeda345057a" => :el_capitan
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
