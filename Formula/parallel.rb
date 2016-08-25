class Parallel < Formula
  desc "GNU parallel shell command"
  homepage "https://savannah.gnu.org/projects/parallel/"
  url "https://ftpmirror.gnu.org/parallel/parallel-20160822.tar.bz2"
  mirror "https://ftp.gnu.org/gnu/parallel/parallel-20160822.tar.bz2"
  sha256 "9867b7d0ebd4964a4bdd38792a77911ca808c91e0f930f5a55651f9e103aabe1"
  head "http://git.savannah.gnu.org/r/parallel.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9b28e16fc1227835d55209cce6a21d4cd6e681316571463a5554481c43367b49" => :el_capitan
    sha256 "dfbd47a069df6fec320b56ce0246280a1338af106dfa7fe407801e5e07ad6af2" => :yosemite
    sha256 "dfbd47a069df6fec320b56ce0246280a1338af106dfa7fe407801e5e07ad6af2" => :mavericks
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
