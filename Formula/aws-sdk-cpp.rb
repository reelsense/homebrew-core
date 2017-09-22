class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  url "https://github.com/aws/aws-sdk-cpp/archive/1.1.50.tar.gz"
  sha256 "bc8ad67c6ec1e8202cad93e2826052f6fdb6fb27041beaf41edbd3bea381cd84"
  head "https://github.com/aws/aws-sdk-cpp.git"

  bottle do
    cellar :any
    sha256 "ff074fd12a45c391d9b25028eb554b7786f95ba62773aa701baf9c3a88661300" => :high_sierra
    sha256 "2856c8dd87aac47cbc1368897861c802c2b196c092b94f3c184e473da0f664fb" => :sierra
    sha256 "f9fc91113f646945cb60d462552b9f6b591dd778dae5945b910af7944b2e90a3" => :el_capitan
    sha256 "d999ff1e3193819e8cc6ee980660bbc6f9b995b6ec52f1912937eb2fda555215" => :yosemite
  end

  option "with-static", "Build with static linking"
  option "without-http-client", "Don't include the libcurl HTTP client"

  depends_on "cmake" => :build

  def install
    args = std_cmake_args
    args << "-DSTATIC_LINKING=1" if build.with? "static"
    args << "-DNO_HTTP_CLIENT=1" if build.without? "http-client"

    mkdir "build" do
      system "cmake", "..", *args
      system "make"
      system "make", "install"
    end

    lib.install Dir[lib/"mac/Release/*"].select { |f| File.file? f }
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <aws/core/Version.h>
      #include <iostream>

      int main() {
          std::cout << Aws::Version::GetVersionString() << std::endl;
          return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-o", "test", "-L#{lib}", "-laws-cpp-sdk-core"
    system "./test"
  end
end
