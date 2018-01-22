require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-3.17.3.tgz"
  sha256 "c1ea3f8b9e12400e53e6e69d017a6fa16d4721cc311d7be094e0849c58c6be60"
  head "https://github.com/firebase/firebase-tools.git"

  bottle do
    sha256 "d4418d67fa1c9eb08d913220bfab476cd059490e9cf7881508c98f2f1e194375" => :high_sierra
    sha256 "3488315a12bce070b46ad5c880f917a5f192210b5d5ac087d2a347ffe8cefd8c" => :sierra
    sha256 "e0473326da4db540b782510372509f6833e017c12aface76b1a28bc8b85dd301" => :el_capitan
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test.exp").write <<~EOS
      spawn #{bin}/firebase login:ci --no-localhost
      expect "Paste"
    EOS
    assert_match "authorization code", shell_output("expect -f test.exp")
  end
end
