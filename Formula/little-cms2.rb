class LittleCms2 < Formula
  desc "Color management engine supporting ICC profiles"
  homepage "http://www.littlecms.com/"
  url "https://downloads.sourceforge.net/project/lcms/lcms/2.9/lcms2-2.9.tar.gz"
  sha256 "00756bed09ce059a68289f10de56b00267667647393ddc30400cb87c0d9037d5"

  bottle do
    cellar :any
    sha256 "92d1a9e56ddf0a885cae2434cba907c7c3023eacf12c5255810aab212faf4355" => :high_sierra
    sha256 "8ed590232348abf555a007b9aa9cd9a612e23f78826cfa4d7883d5e86157a40b" => :sierra
    sha256 "9c1e5c2040ffcfea2e52493ff6084655c210bbe2c09b35da0a64fa37d63fe708" => :el_capitan
  end

  depends_on "jpeg" => :recommended
  depends_on "libtiff" => :recommended

  def install
    args = %W[--disable-dependency-tracking --prefix=#{prefix}]
    args << "--without-tiff" if build.without? "libtiff"
    args << "--without-jpeg" if build.without? "jpeg"

    system "./configure", *args
    system "make", "install"
  end

  test do
    system "#{bin}/jpgicc", test_fixtures("test.jpg"), "out.jpg"
    assert_predicate testpath/"out.jpg", :exist?
  end
end
