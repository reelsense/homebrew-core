class GribApi < Formula
  desc "Encode and decode grib messages (editions 1 and 2)"
  homepage "https://software.ecmwf.int/wiki/display/GRIB/Home"
  url "https://software.ecmwf.int/wiki/download/attachments/3473437/grib_api-1.18.0-Source.tar.gz"
  sha256 "dfffeeb4df715b234907cb12d6729617bed0df0ff023337c2dd3cd20ab58199e"

  bottle do
    sha256 "afe0ad7af07bbe0855156c20b07033046a31eea7a070ef18a18fc592815b0f1f" => :sierra
    sha256 "af4073a49a98e47821b2916043bd007cc0496ba79183e3b7d834f23cc2103f0e" => :el_capitan
    sha256 "607400333b883af9f15371d405f71a7d4e1b0ecad1e68f81da9a3ffb91f9ec34" => :yosemite
  end

  option "with-static", "Build static instead of shared library."

  depends_on "cmake" => :build
  depends_on "jasper" => :recommended
  depends_on "libpng" => :optional
  depends_on :fortran

  def install
    mkdir "build" do
      args = std_cmake_args
      args << "-DBUILD_SHARED_LIBS=OFF" if build.with? "static"

      if build.with? "libpng"
        args << "-DPNG_PNG_INCLUDE_DIR=#{Formula["libpng"].opt_include}"
        args << "-DENABLE_PNG=ON"
      end

      system "cmake", "..", *args
      system "make", "install"
    end
  end

  test do
    grib_samples_path = shell_output("#{bin}/grib_info -t").strip
    system bin/"grib_ls", "#{grib_samples_path}/GRIB1.tmpl"
    system bin/"grib_ls", "#{grib_samples_path}/GRIB2.tmpl"
  end
end
