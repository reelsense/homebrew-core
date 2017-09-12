require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-1.4.1.tgz"
  sha256 "eafd7ba18be63a4fa3e32ad11f45de8ab3111367f4fd8b9a132451932f1719a5"

  bottle do
    sha256 "df5e9504ed459c01876da2137afeab06bd8cf939cd395e8c293f066c805e9a01" => :sierra
    sha256 "f062366d023f540db00056a806e2c39715df73a8db3293233764f8b80f2b20eb" => :el_capitan
    sha256 "8572f03fe6e82a4c7a1b548add5e8117ba7125616d3751552dfd95b032defd05" => :yosemite
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"ng", "new", "--skip-install", "angular-homebrew-test"
    assert File.exist?("angular-homebrew-test/package.json"), "Project was not created"
  end
end
