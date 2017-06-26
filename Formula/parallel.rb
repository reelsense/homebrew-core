class Parallel < Formula
  desc "Shell command parallelization utility"
  homepage "https://savannah.gnu.org/projects/parallel/"
  url "https://ftp.gnu.org/gnu/parallel/parallel-20170622.tar.bz2"
  mirror "https://ftpmirror.gnu.org/parallel/parallel-20170622.tar.bz2"
  sha256 "b3324ca1e7553b9903e0ab1fbb461334986eadfcd9b33e09013a6bac3c279645"
  head "https://git.savannah.gnu.org/git/parallel.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "af02d237a94ddd8d5d18287026a1da8a6afc6a79dc84f20ef723faba0ca74249" => :sierra
    sha256 "5c79705f86d6caef4d761a11394cde9f092c81e64f5966644ca04a5ddf74ff3b" => :el_capitan
    sha256 "5c79705f86d6caef4d761a11394cde9f092c81e64f5966644ca04a5ddf74ff3b" => :yosemite
  end

  conflicts_with "moreutils", :because => "both install a 'parallel' executable."

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_equal "test\ntest\n",
                 shell_output("#{bin}/parallel --will-cite echo ::: test test")
  end
end
