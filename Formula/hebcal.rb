class Hebcal < Formula
  desc "Perpetual Jewish calendar for the command-line"
  homepage "https://github.com/hebcal/hebcal"
  url "https://github.com/hebcal/hebcal/archive/v4.11.tar.gz"
  sha256 "3b32b579c1153e29572b81c0b10a019c983200ac13f5423fff5caab10de28a5e"

  bottle do
    cellar :any_skip_relocation
    sha256 "b3741be3e85ea4b46eb2556e60a30c1d1a36ddc8ce10a17cf0c0d9c889d63ea5" => :sierra
    sha256 "7cd593d37eceaa17e8a00b86fc3865aa24b2f23303a77fd3d7c62cbf2a3a3ca3" => :el_capitan
    sha256 "9f8588f08f33d8056f1416ed65ca47418a83b3c5a07469fe3eae289ad1b8bc97" => :yosemite
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  def install
    system "./configure", "--prefix=#{prefix}", "ACLOCAL=aclocal", "AUTOMAKE=automake"
    system "make", "install"
  end

  test do
    system "#{bin}/hebcal"
  end
end
