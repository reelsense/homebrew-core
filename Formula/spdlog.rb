class Spdlog < Formula
  desc "Super fast C++ logging library"
  homepage "https://github.com/gabime/spdlog"
  url "https://github.com/gabime/spdlog/archive/v0.16.2.tar.gz"
  sha256 "2081e5df5e87402398847431e16b87c71dd5c4d632314bb976ace8161f4d32de"
  head "https://github.com/gabime/spdlog.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3e32244b44d681a55d444eeb76b6dfb106db49020c4b8f8a41b0c242ec4f83dd" => :high_sierra
    sha256 "3e32244b44d681a55d444eeb76b6dfb106db49020c4b8f8a41b0c242ec4f83dd" => :sierra
    sha256 "3e32244b44d681a55d444eeb76b6dfb106db49020c4b8f8a41b0c242ec4f83dd" => :el_capitan
  end

  depends_on "cmake" => :build

  needs :cxx11

  def install
    ENV.cxx11

    mkdir "spdlog-build" do
      args = std_cmake_args
      args << "-Dpkg_config_libdir=#{lib}" << ".."
      system "cmake", *args
      system "make", "install"
    end
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include "spdlog/spdlog.h"
      #include <iostream>
      #include <memory>
      int main()
      {
        auto console = spdlog::stdout_logger_mt("console");
      }
    EOS
    system ENV.cxx, "-std=c++11", "test.cpp", "-I#{include}", "-o", "test"
    system "./test"
  end
end
