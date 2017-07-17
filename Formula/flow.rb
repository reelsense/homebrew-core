class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.50.0.tar.gz"
  sha256 "859b6f5e1fce4d5813591fbc08e60605630d0b15e1825f877876ecd1476b8fdd"
  revision 1
  head "https://github.com/facebook/flow.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "79f6be28709fec82fff462efaa6e1e3b4d5a9331c8305fdf51b7dc5d7058ee50" => :sierra
    sha256 "ce1f97bbd3d5efc2e19943da36359f1e803802550e4fdfe6c5fbd6583a053c1b" => :el_capitan
    sha256 "e1b5afbcbb083a0c22a69d7843484a23f730adb62a8edaf133b91de12e038ecc" => :yosemite
  end

  depends_on "ocaml" => :build
  depends_on "opam" => :build

  def install
    system "make", "all-homebrew"

    bin.install "bin/flow"

    bash_completion.install "resources/shell/bash-completion" => "flow-completion.bash"
    zsh_completion.install_symlink bash_completion/"flow-completion.bash" => "_flow"
  end

  test do
    system "#{bin}/flow", "init", testpath
    (testpath/"test.js").write <<-EOS.undent
      /* @flow */
      var x: string = 123;
    EOS
    expected = /Found 1 error/
    assert_match expected, shell_output("#{bin}/flow check #{testpath}", 2)
  end
end
