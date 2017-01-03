class Parallel < Formula
  desc "GNU parallel shell command"
  homepage "https://savannah.gnu.org/projects/parallel/"
  url "https://ftpmirror.gnu.org/parallel/parallel-20161222.tar.bz2"
  mirror "https://ftp.gnu.org/gnu/parallel/parallel-20161222.tar.bz2"
  sha256 "2714be9b6957ce6ddb268e8aa97f463d8eac97e55612cc055ef030afd9c80fb2"
  head "http://git.savannah.gnu.org/r/parallel.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f874986dcf690454082057c0e984780ee9f17ee1959ed6c166401d0e849d9ea0" => :sierra
    sha256 "e5a3b08951d77afa5a75027c7832fb09e83cad81d8abfa6d39774c624562acfe" => :el_capitan
    sha256 "e5a3b08951d77afa5a75027c7832fb09e83cad81d8abfa6d39774c624562acfe" => :yosemite
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
