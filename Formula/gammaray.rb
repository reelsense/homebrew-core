class Gammaray < Formula
  desc "Examine and manipulate Qt application internals at runtime"
  homepage "https://www.kdab.com/kdab-products/gammaray/"
  url "https://github.com/KDAB/GammaRay/releases/download/v2.5.1/gammaray-2.5.1.tar.gz"
  sha256 "fd493d4b53fdd05f288f7a8ae0f414faa38c5626269643eec64a0a858e854c61"
  head "https://github.com/KDAB/GammaRay.git"

  bottle do
    sha256 "cd595453f2ca78548c5646bd3a28424842ebe31c9ce3d9247d791c81cf8eb575" => :el_capitan
    sha256 "9e2f25b9236df44f44c5e9b31ee0a0d7c95b0b454d24be7ebd3c6527cf99a22e" => :yosemite
    sha256 "3d3aa7bbd331b7d4d7a994235786431133ba185a0899ba594bf5a65b518bcc00" => :mavericks
  end

  option "with-vtk", "Build with VTK-with-Qt support, for object 3D visualizer"
  option "with-test", "Verify the build with `make test`"

  needs :cxx11

  depends_on "cmake" => :build
  depends_on "qt5"
  depends_on "graphviz" => :recommended

  # VTK needs to have Qt support, and it needs to match GammaRay's
  depends_on "homebrew/science/vtk" => [:optional, "with-qt5"]

  def install
    # For Mountain Lion
    ENV.libcxx

    # attachtest-lldb causes "make check" to fail
    # Reported 31 Jul 2016: https://github.com/KDAB/GammaRay/issues/241
    inreplace "tests/CMakeLists.txt", "/gammaray lldb", "/gammaray nosuchfile"

    args = std_cmake_args
    args << "-DCMAKE_DISABLE_FIND_PACKAGE_VTK=" + ((build.without? "vtk") ? "ON" : "OFF")
    args << "-DCMAKE_DISABLE_FIND_PACKAGE_Graphviz=" + ((build.without? "graphviz") ? "ON" : "OFF")

    system "cmake", *args
    system "make"
    system "make", "test" if build.bottle? || build.with?("test")
    system "make", "install"
  end

  test do
    (prefix/"GammaRay.app/Contents/MacOS/gammaray").executable?
  end
end
