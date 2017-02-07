class Cmocka < Formula
  desc "Unit testing framework for C"
  homepage "https://cmocka.org/"
  url "https://cmocka.org/files/1.1/cmocka-1.1.0.tar.xz"
  sha256 "e960d3bf1be618634a4b924f18bb4d6f20a825c109a8ad6d1af03913ba421330"

  bottle do
    cellar :any
    rebuild 1
    sha256 "728fa205df7a8e1efd39ddba0bc770d9d312dda20f54945baad099db272e011f" => :sierra
    sha256 "c88eec638bf6414a40ce20b2e5bb2160b50abe639c83e3ae8b138ac12568e3e9" => :el_capitan
    sha256 "d64fb55ed84223d2737f1e0902e522a83ced3c29fa196320a1bbe9f0655c7581" => :yosemite
  end

  depends_on "cmake" => :build

  def install
    args = std_cmake_args
    args << "-DWITH_STATIC_LIB=ON" << "-DWITH_CMOCKERY_SUPPORT=ON" << "-DUNIT_TESTING=ON"
    if MacOS.version == "10.11" && MacOS::Xcode.installed? && MacOS::Xcode.version >= "8.0"
      args << "-DHAVE_CLOCK_GETTIME:INTERNAL=0"
    end

    mkdir "build" do
      system "cmake", "..", *args
      system "make"
      system "make", "install"
    end
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <stdarg.h>
      #include <stddef.h>
      #include <setjmp.h>
      #include <cmocka.h>

      static void null_test_success(void **state) {
        (void) state; /* unused */
      }

      int main(void) {
        const struct CMUnitTest tests[] = {
            cmocka_unit_test(null_test_success),
        };
        return cmocka_run_group_tests(tests, NULL, NULL);
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lcmocka", "-o", "test"
    system "./test"
  end
end
