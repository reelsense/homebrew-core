class BoostBcp < Formula
  desc "Utility for extracting subsets of the Boost library"
  homepage "https://www.boost.org/doc/tools/bcp/"
  url "https://downloads.sourceforge.net/project/boost/boost/1.61.0/boost_1_61_0.tar.bz2"
  sha256 "a547bd06c2fd9a71ba1d169d9cf0339da7ebf4753849a8f7d6fdb8feee99b640"

  head "https://github.com/boostorg/boost.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "43f9adea3dff5da4d8f8e23a7e0823e0e712f60b9196a418b315e957ff109dcd" => :el_capitan
    sha256 "87289c469edfd5fb2c348e4c05c7cd7131f7f34b0d3b017ad970df03a956d7f9" => :yosemite
    sha256 "a1e8bf11a68d5f45be408594951409b8e595501f08d950920cda3404a1880d4c" => :mavericks
  end

  depends_on "boost-build" => :build

  def install
    cd "tools/bcp" do
      system "b2"
      prefix.install "../../dist/bin"
    end
  end

  test do
    system bin/"bcp", "--help"
  end
end
