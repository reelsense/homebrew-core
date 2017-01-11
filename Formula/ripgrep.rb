class Ripgrep < Formula
  desc "Search tool like grep and The Silver Searcher."
  homepage "https://github.com/BurntSushi/ripgrep"
  url "https://github.com/BurntSushi/ripgrep/archive/0.3.2.tar.gz"
  sha256 "aea775c9ead5ee2b10b7cdebdb9387f5d6a400b96e5bfe26ccec7e44dd666617"
  head "https://github.com/BurntSushi/ripgrep.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "794e57f83c0a1047d471341aaaeb23bbb094712d7eded95176c8ba35791f9814" => :sierra
    sha256 "aad612ceaed999ec278b257d8fb7227d975d7d17776c5947024e49f24a85e99d" => :el_capitan
    sha256 "ff54de0b23742e4bcdfc3de9047116fc293674c8ca40218daed25902e847f40e" => :yosemite
  end

  depends_on "rust" => :build

  def install
    system "cargo", "build", "--release"

    bin.install "target/release/rg"
    man1.install "doc/rg.1"

    # Completion scripts are generated in the crate's build directory, which
    # includes a fingerprint hash. Try to locate it first
    out_dir = Dir["target/release/build/ripgrep-*/out"].first
    bash_completion.install "#{out_dir}/rg.bash-completion"
    fish_completion.install "#{out_dir}/rg.fish"
  end

  test do
    (testpath/"Hello.txt").write("Hello World!")
    system "#{bin}/rg", "Hello World!", testpath
  end
end
