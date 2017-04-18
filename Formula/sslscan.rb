class Sslscan < Formula
  desc "Test SSL/TLS enabled services to discover supported cipher suites."
  homepage "https://github.com/rbsec/sslscan"
  url "https://github.com/rbsec/sslscan/archive/1.11.9-rbsec.tar.gz"
  version "1.11.9"
  sha256 "9417061a8f827b02b2b6457031888b1ae0b299460714ce3d9192432afde3a9cb"
  head "https://github.com/rbsec/sslscan.git"

  bottle do
    cellar :any
    sha256 "e50ac88f3e2cd18881fb7f5547a6f14c400c7e963474b7147cabe9ab245c3bbb" => :sierra
    sha256 "925812c9ae699020d5237a47508aa51c0ed57ce305aebb2151440412a8f79405" => :el_capitan
    sha256 "218de341f71de197b41795f83b3681ea5b861aae89a8de0f81e08bb41b44caf2" => :yosemite
  end

  depends_on "openssl"

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/sslscan", "google.com"
  end
end
