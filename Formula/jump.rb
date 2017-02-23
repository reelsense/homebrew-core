class Jump < Formula
  desc "Quick and fuzzy directory jumper."
  homepage "https://github.com/gsamokovarov/jump"
  url "https://github.com/gsamokovarov/jump/archive/v0.10.0.tar.gz"
  sha256 "6826d353f9724c7dd417479fd9aea396d63463962e38682154964c07072a61fc"
  head "https://github.com/gsamokovarov/jump.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5211008a3c504ed7a98ff7ec58b428c7d2c627ea7ca8080aec21cc02497d0f1b" => :sierra
    sha256 "4b2ed1684d412a524e60bed5f7e76716bbe8b7348bd5160b740269bebbd42bba" => :el_capitan
    sha256 "08f76c97fb3f0da4f59685155a8a9d26c120c5b920275ecd8b8b6e43b2b5c397" => :yosemite
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/gsamokovarov").mkpath
    ln_s buildpath, buildpath/"src/github.com/gsamokovarov/jump"

    system "go", "build", "-o", "#{bin}/jump"
    man1.install "man/jump.1"
  end

  test do
    (testpath/"test_dir").mkpath
    ENV["JUMP_HOME"] = testpath.to_s
    system "#{bin}/jump", "chdir", "#{testpath}/test_dir"

    assert_equal (testpath/"test_dir").to_s, shell_output("#{bin}/jump cd tdir").chomp
  end
end
