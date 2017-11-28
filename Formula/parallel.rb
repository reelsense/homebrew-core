class Parallel < Formula
  desc "Shell command parallelization utility"
  homepage "https://savannah.gnu.org/projects/parallel/"
  url "https://ftp.gnu.org/gnu/parallel/parallel-20171122.tar.bz2"
  mirror "https://ftpmirror.gnu.org/parallel/parallel-20171122.tar.bz2"
  sha256 "41b46add38eecad3026e0086c1fb01cfa13c7cc24ecf91cd595e22f83fca82a6"
  head "https://git.savannah.gnu.org/git/parallel.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "75e7cd695fd74fc4c7ac11edea5e6a8d758997fbe73a54cd2556ec342dc7a373" => :high_sierra
    sha256 "75e7cd695fd74fc4c7ac11edea5e6a8d758997fbe73a54cd2556ec342dc7a373" => :sierra
    sha256 "75e7cd695fd74fc4c7ac11edea5e6a8d758997fbe73a54cd2556ec342dc7a373" => :el_capitan
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
