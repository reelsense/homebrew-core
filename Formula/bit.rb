require "language/node"

class Bit < Formula
  desc "Distributed Code Component Manager"
  homepage "https://www.bitsrc.io"
  url "https://registry.npmjs.org/bit-bin/-/bit-bin-0.10.7.tgz"
  sha256 "d033b76974be7103933abe1fc937297d29c19aa1cdabbba8d5032ebd9d4f72f0"
  head "https://github.com/teambit/bit.git"

  bottle do
    sha256 "0e00d7cdb1da0e636a21134b33964b16740c33230ebf71718d5275f486440030" => :high_sierra
    sha256 "c64efc7326daf26db022b41ed20875f4e142018c39c736c3a8c98af9fc8f313b" => :sierra
    sha256 "d48e4cd09f6cb35938a2a079cfcffdedcba88badbe8ef269f120e51302ebf0b9" => :el_capitan
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_equal "successfully initialized an empty bit scope.\n",
                 shell_output("#{bin}/bit init --skip-update")
  end
end
