class Nickle < Formula
  desc "Desk calculator language"
  homepage "https://www.nickle.org/"
  url "https://www.nickle.org/release/nickle-2.79.tar.gz"
  sha256 "d8b25f788545e036f2b2fd9c246d7f3143ac8d4fd35378784d9cbb4325e5077f"

  bottle do
    sha256 "32d7348bd2d8201b3e72a875d2b8f9de280cdeb15b43d8c5cf635941f7807ee5" => :high_sierra
    sha256 "a4bf85c667af66a966bfba67f0bc3caea752ae13a808133c928509c80edca796" => :sierra
    sha256 "40df920677e85b1ded1911a88e70d46b35c1379fa06ef60e96bbff3b3990ae16" => :el_capitan
  end

  depends_on "readline"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_equal "4", shell_output("#{bin}/nickle -e '2+2'").chomp
  end
end
