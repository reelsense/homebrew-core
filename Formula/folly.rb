class Folly < Formula
  desc "Collection of reusable C++ library artifacts developed at Facebook"
  homepage "https://github.com/facebook/folly"
  url "https://github.com/facebook/folly/archive/v2017.03.06.00.tar.gz"
  sha256 "e48507f08cb3ec071d756c2a3c49177a99566566375ab7fb0f351fcb8690ada1"
  head "https://github.com/facebook/folly.git"

  bottle do
    cellar :any
    sha256 "7fdb7ded2e05c95d1b00f48ae6d609bcf10ac66c5b0694d8cc741c7d1e52d32a" => :sierra
    sha256 "9111e934c9b6596f82b7925f7b5ebd82d6a2649e42068b1fcdf3e3a44be3aedd" => :el_capitan
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "double-conversion"
  depends_on "glog"
  depends_on "gflags"
  depends_on "boost"
  depends_on "libevent"
  depends_on "xz"
  depends_on "snappy"
  depends_on "lz4"
  depends_on "openssl"

  # https://github.com/facebook/folly/issues/451
  depends_on :macos => :el_capitan

  needs :cxx11

  # Known issue upstream. They're working on it:
  # https://github.com/facebook/folly/pull/445
  fails_with :gcc => "6"

  def install
    ENV.cxx11

    cd "folly" do
      # Fix "typedef redefinition with different types ('uint8_t' (aka 'unsigned
      # char') vs 'enum clockid_t')"
      # Reported 9 Mar 2017 https://github.com/facebook/folly/issues/557
      if MacOS.version == "10.11" && MacOS::Xcode.installed? && MacOS::Xcode.version >= "8.0"
        inreplace "portability/Time.h", "typedef uint8_t clockid_t;", ""
      end

      system "autoreconf", "-fvi"
      system "./configure", "--prefix=#{prefix}", "--disable-silent-rules",
                            "--disable-dependency-tracking"
      system "make"
      system "make", "install"
    end
  end

  test do
    (testpath/"test.cc").write <<-EOS.undent
      #include <folly/FBVector.h>
      int main() {
        folly::fbvector<int> numbers({0, 1, 2, 3});
        numbers.reserve(10);
        for (int i = 4; i < 10; i++) {
          numbers.push_back(i * 2);
        }
        assert(numbers[6] == 12);
        return 0;
      }
    EOS
    system ENV.cxx, "-std=c++11", "test.cc", "-I#{include}", "-L#{lib}",
                    "-lfolly", "-o", "test"
    system "./test"
  end
end
