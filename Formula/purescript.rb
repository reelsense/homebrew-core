require "language/haskell"

class Purescript < Formula
  include Language::Haskell::Cabal

  desc "Strongly typed programming language that compiles to JavaScript"
  homepage "http://www.purescript.org"
  url "https://github.com/purescript/purescript/archive/v0.10.5.tar.gz"
  sha256 "cb38d14e353bf200471385dd08dc5108f4f8690a76806e79c8f2fb3f8facca9c"
  head "https://github.com/purescript/purescript.git"

  bottle do
    sha256 "c384fb0ebb7229d5a329a75624430eda19fa703a45673cf323ce4f173c39577f" => :sierra
    sha256 "36d657fbbe5b709d8870dc737326f749f26e4734f0e2df6f03cc65144a110334" => :el_capitan
    sha256 "fe61f809dd28fed3ea6c3c0df4ff3d69e66bcba82e2311419671d626c2b7c8fe" => :yosemite
  end

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build

  def install
    install_cabal_package "--allow-newer=turtle:directory",
                          "--constraint", "directory < 1.4",
                          :using => ["alex", "happy"]
  end

  test do
    test_module_path = testpath/"Test.purs"
    test_target_path = testpath/"test-module.js"
    test_module_path.write <<-EOS.undent
      module Test where

      main :: Int
      main = 1
    EOS
    system bin/"psc", test_module_path, "-o", test_target_path
    assert File.exist?(test_target_path)
  end
end
