class Gjstest < Formula
  desc "Fast javascript unit testing framework that runs on the V8 engine."
  homepage "https://github.com/google/gjstest"
  url "https://github.com/google/gjstest/archive/v1.0.2.tar.gz"
  sha256 "7bf0de1c4b880b771a733c9a5ce07c71b93f073e6acda09bec7e400c91c2057c"
  revision 8
  head "https://github.com/google/gjstest.git"

  bottle do
    sha256 "7f6818b7c4d23d6a3257afe2f87af5405462925c951261e6d74c94d263aadfaa" => :sierra
    sha256 "4456d14326677b01218259a0a27bf076ed30e36947adf254830d8387646ecf18" => :el_capitan
    sha256 "7526752e6da251f720682acf64153499995ceb142b1ce237332e34701cb7ee50" => :yosemite
  end

  depends_on :macos => :mavericks

  depends_on "gflags"
  depends_on "glog"
  depends_on "libxml2"
  depends_on "protobuf"
  depends_on "re2"
  depends_on "v8"

  def install
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    (testpath/"sample_test.js").write <<-EOF
      function SampleTest() {
      }
      registerTestSuite(SampleTest);

      addTest(SampleTest, function twoPlusTwoEqualsFour() {
        expectEq(4, 2+2);
      });
    EOF

    system "#{bin}/gjstest", "--js_files", "#{testpath}/sample_test.js"
  end
end
