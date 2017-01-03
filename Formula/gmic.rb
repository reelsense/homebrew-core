class Gmic < Formula
  desc "Full-Featured Open-Source Framework for Image Processing"
  homepage "https://gmic.eu/"
  url "https://gmic.eu/files/source/gmic_1.7.9.1.tar.gz"
  sha256 "152f100eb139a5f6e5b3d1e43aaed34f2b3786f72f52724ebde5e5ccea2c7133"
  head "https://github.com/dtschump/gmic.git"

  bottle do
    cellar :any
    sha256 "a29a1d45e967f14ee748f041169e4dedce7444f3a33fced4e1983d601aaabe51" => :sierra
    sha256 "7142932838ea10b26c94a11ab8ba3992f8773fe787836ceac06cf10e35e92a47" => :el_capitan
    sha256 "34a3c667311ce14c54843b37b3a2846ee86958d818da0d660e8b33adb430eb48" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "jpeg" => :recommended
  depends_on "libpng" => :recommended
  depends_on "fftw" => :recommended
  depends_on "homebrew/science/opencv" => :optional
  depends_on "ffmpeg" => :optional
  depends_on "libtiff" => :optional
  depends_on "openexr" => :optional

  def install
    args = std_cmake_args
    args << "-DENABLE_X=OFF"
    args << "-DENABLE_JPEG=OFF" if build.without? "jpeg"
    args << "-DENABLE_PNG=OFF" if build.without? "libpng"
    args << "-DENABLE_FFTW=OFF" if build.without? "fftw"
    args << "-DENABLE_OPENCV=OFF" if build.without? "opencv"
    args << "-DENABLE_FFMPEG=OFF" if build.without? "ffmpeg"
    args << "-DENABLE_TIFF=OFF" if build.without? "libtiff"
    args << "-DENABLE_OPENEXR=OFF" if build.without? "openexr"
    system "cmake", *args
    system "make", "install"
  end

  test do
    %w[test.jpg test.png].each do |file|
      system bin/"gmic", test_fixtures(file)
    end
  end
end
