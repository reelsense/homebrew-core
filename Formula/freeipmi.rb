class Freeipmi < Formula
  desc "In-band and out-of-band IPMI (v1.5/2.0) software"
  homepage "https://www.gnu.org/software/freeipmi/"
  url "https://ftp.gnu.org/gnu/freeipmi/freeipmi-1.5.6.tar.gz"
  mirror "https://ftpmirror.gnu.org/freeipmi/freeipmi-1.5.6.tar.gz"
  sha256 "2b1abdc455ffb0e5017cf4d669f549079d3559ad57a73677611e76cec5a06c5c"

  bottle do
    sha256 "5c1f1819f862cbd86176d4b533144d978ef075ee3684c76e68cedaee9dcc9262" => :sierra
    sha256 "fc90e19e94fdbda9f5fc6487d88de960bd3849ab70a14ce58b473b9c5273f426" => :el_capitan
    sha256 "c54b220f158157b18c2f2ba0fb06226aa609886f816561294775c8f7d9ed354c" => :yosemite
  end

  depends_on "argp-standalone"
  depends_on "libgcrypt"

  def install
    inreplace "man/Makefile.in",
      "$(CPP) -nostdinc -w -C -P -I$(top_srcdir)/man $@.pre  $@",
      "$(CPP) -nostdinc -w -C -P -I$(top_srcdir)/man $@.pre > $@"

    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system sbin/"ipmi-fru", "--version"
  end
end
