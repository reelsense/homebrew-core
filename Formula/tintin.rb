class Tintin < Formula
  desc "MUD client"
  homepage "https://tintin.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/tintin/TinTin%2B%2B%20Source%20Code/2.01.1/tintin-2.01.1.tar.gz"
  sha256 "cc0ba550880bd5efdba8fde11d1e4ddd4ae8737f81e6f64649de23ed99cbbca4"

  bottle do
    cellar :any
    sha256 "53ef21f8401cc2eb2382025308d7f60ce526dc767ac5f2da27c83779c9601d8c" => :sierra
    sha256 "2da30697e6faf758f370e4f94c6481e6ea01d19eb66302a29f2e6205a94d3744" => :el_capitan
    sha256 "8e7c563ee4dc513ac7890da9f2d6e6f72be399c46af02444f5e09b50e7a84d95" => :yosemite
  end

  depends_on "pcre"

  def install
    # find Homebrew's libpcre
    ENV.append "LDFLAGS", "-L#{HOMEBREW_PREFIX}/lib"

    cd "src" do
      system "./configure", "--prefix=#{prefix}"
      system "make", "CFLAGS=#{ENV.cflags}",
                     "INCS=#{ENV.cppflags}",
                     "LDFLAGS=#{ENV.ldflags}",
                     "install"
    end
  end
end
