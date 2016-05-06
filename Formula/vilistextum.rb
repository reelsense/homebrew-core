class Vilistextum < Formula
  desc "HTML to text converter"
  homepage "https://bhaak.net/vilistextum/"
  url "https://bhaak.net/vilistextum/vilistextum-2.6.9.tar.gz"
  sha256 "3a16b4d70bfb144e044a8d584f091b0f9204d86a716997540190100c20aaf88d"

  bottle do
    cellar :any_skip_relocation
    sha256 "d46bae51c7e9a7193a735660af8583960c98e50f03aa33c8a9d81c22b2d9bf61" => :el_capitan
    sha256 "77ab66b58db8649e9444584b5ee85e6c6c7badeb665425263c50282367eea003" => :yosemite
    sha256 "be608cbb3892c81f92392253a86456f042e804b55c58e1331a01531781137f74" => :mavericks
    sha256 "40d71172fde61fe9bb297b411fabb64bcc2b915036da2a531c56e1d84382131d" => :mountain_lion
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--mandir=#{man}"
    system "make", "install"
  end

  test do
    system "#{bin}/vilistextum", "-v"
  end
end
