class Faad2 < Formula
  desc "ISO AAC audio decoder"
  homepage "http://www.audiocoding.com/faad2.html"
  url "https://downloads.sourceforge.net/project/faac/faad2-src/faad2-2.8.0/faad2-2.8.3.tar.gz"
  sha256 "9e4fd094080c27f6f419f3fe1fce369621b9469de396e126405153784134da00"

  bottle do
    cellar :any
    sha256 "40909a4ad9969a5a2634678fe44b1aacb076abf159b6006c16746d91e61b9a79" => :high_sierra
    sha256 "7c3d0b7c58da02be5a2a9e0764e64aecc04083a8bd2b69399af472b4ac843252" => :sierra
    sha256 "65c4ff67358a9f81bbc9b137c77960d95721807c44b2feacc9a7bcd50ce842c7" => :el_capitan
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match "infile.mp4", shell_output("#{bin}/faad -h", 1)
  end
end
