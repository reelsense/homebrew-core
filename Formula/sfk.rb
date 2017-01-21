class Sfk < Formula
  desc "Command Line Tools Collection"
  homepage "http://stahlworks.com/dev/swiss-file-knife.html"
  url "https://downloads.sourceforge.net/project/swissfileknife/1-swissfileknife/1.8.2/sfk-1.8.2.tar.gz"
  sha256 "028e062463185345172983bfcd099f4b00e5ef7bccc1f5b4902f42868194219c"

  bottle do
    cellar :any_skip_relocation
    sha256 "2c7e7ae2363eabeac65d00ca5eef0000b833a4292ac04e6a65eb463e943a99c8" => :sierra
    sha256 "2381b06258528bf09b607565253fa5de283c2e8de62851f9d6561f1740d1a7f8" => :el_capitan
    sha256 "cf8b51a51b311491b92366b1a4fd10141d06809ed08a3f7070c3c4f1fd64d558" => :yosemite
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    # permission issue fixed in version 1.8.1 (HEAD)
    chmod 0755, "install-sh"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/sfk", "ip"
  end
end
