require "language/node"

class Yarn < Formula
  desc "Javascript package manager"
  homepage "https://yarnpkg.com/"
  url "https://yarnpkg.com/downloads/0.20.3/yarn-v0.20.3.tar.gz"
  sha256 "e7d052aba18716616213a602d66528eda7a2bdda7962fc23644ce53e74b1e1d5"
  head "https://github.com/yarnpkg/yarn.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "8aac9fa3e9139954c6fe8bedadb06c14a810a8e74b729149131bb01e368298b4" => :sierra
    sha256 "d42c83b5bba0c9ebe80b4d46d9b6070ba8c1e2cdb4c2a92c020ae27de49a92f4" => :el_capitan
    sha256 "9e6ec3ef6054d1058cf2bce2e30abfcc6c478139b40065acd90ac8fd06378a38" => :yosemite
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"package.json").write('{"name": "test"}')
    system bin/"yarn", "add", "jquery"
  end
end
