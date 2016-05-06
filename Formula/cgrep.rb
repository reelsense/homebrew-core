require "language/haskell"

class Cgrep < Formula
  include Language::Haskell::Cabal

  desc "Context-aware grep for source code"
  homepage "https://github.com/awgn/cgrep"
  url "https://github.com/awgn/cgrep/archive/v6.6.3.tar.gz"
  sha256 "50216341ba024e6a6b6192ff879ed6b8bc8be5255010e0bbbf6fb36d1c495225"
  head "https://github.com/awgn/cgrep.git"

  bottle do
    sha256 "5a14f4c94d9e1e6373c09cd3286f816bf62cf84270cd05ef5ba8eb48a4e69897" => :el_capitan
    sha256 "1cb1079509dc4cb880c13a52d27d759ccae33d6085f1a8ac053eab8ca190b04c" => :yosemite
    sha256 "448e2deaa0128fcf54be47ccb4933c42e21cfc2cffe015aa2dcdd0013c066133" => :mavericks
  end

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build
  depends_on "pcre"

  def install
    install_cabal_package
  end

  test do
    path = testpath/"test.rb"
    path.write <<-EOS.undent
      # puts test comment.
      puts "test literal."
    EOS

    assert_match ":1",
      shell_output("script -q /dev/null #{bin}/cgrep --count --comment test #{path}")
    assert_match ":1",
      shell_output("script -q /dev/null #{bin}/cgrep --count --literal test #{path}")
    assert_match ":1",
      shell_output("script -q /dev/null #{bin}/cgrep --count --code puts #{path}")
  end
end
