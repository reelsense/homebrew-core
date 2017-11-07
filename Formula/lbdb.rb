class Lbdb < Formula
  desc "Little brother's database for the mutt mail reader"
  homepage "https://www.spinnaker.de/lbdb/"
  url "https://www.spinnaker.de/debian/lbdb_0.45.1.tar.xz"
  sha256 "0187bf8330d023a5b156035762d1fc0ec48158287da4d9d6ee4992e2618e91c9"

  bottle do
    cellar :any_skip_relocation
    sha256 "b4cc801045e092ae0b058b75a6cb7f81f8893d3b07f3eaafb2948d7c3df3dcc2" => :high_sierra
    sha256 "882b4e523c320bc2dbd1713e0e382fc266385a3cc23fdb23b16c5cf30597de0c" => :sierra
    sha256 "bea6a57a7c3da1a7cf3c1672af2a957d8f04bb7f6a4f0599bfafa176803eebb2" => :el_capitan
  end

  depends_on "abook" => :recommended

  def install
    system "./configure", "--prefix=#{prefix}", "--libdir=#{lib}/lbdb"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lbdbq -v")
  end
end
