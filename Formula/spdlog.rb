class Spdlog < Formula
  desc "Super fast C++ logging library."
  homepage "https://github.com/gabime/spdlog"
  url "https://github.com/gabime/spdlog/archive/v0.11.0.tar.gz"
  sha256 "8c0f1810fb6b7d23fef70c2ea8b6fa6768ac8d18d6e0de39be1f48865e22916e"
  head "https://github.com/gabime/spdlog.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "4b375facceceff48cf5da46f160890412adb6c9173b52b73a6be35c3a773947b" => :sierra
    sha256 "844b241b922e72e637ff3cfe7c4793fb4fd7676be86d148db64a07f2ef68207f" => :el_capitan
    sha256 "4b375facceceff48cf5da46f160890412adb6c9173b52b73a6be35c3a773947b" => :yosemite
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
    (testpath/"test.cpp").write <<-EOS.undent
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
