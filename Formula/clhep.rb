class Clhep < Formula
  desc "Class Library for High Energy Physics"
  homepage "https://proj-clhep.web.cern.ch/proj-clhep/"
  url "https://proj-clhep.web.cern.ch/proj-clhep/DISTRIBUTION/tarFiles/clhep-2.4.0.0.tgz"
  sha256 "5e5cf284323898b4c807db6e684d65d379ade65fe0e93f7b10456890a6dee8cc"

  bottle do
    cellar :any
    sha256 "72c875560e99c39792098fbf5bc0beb54dcb3cc4cac18e5db743ee96dd956524" => :high_sierra
    sha256 "352becea36eac3099edb9d23e3ecfc6dee198b4c4c20c0e27399a7870c6e3327" => :sierra
    sha256 "b6fc60f006eff93d7ef57e9e8b7c8e5e44e1bc671280f5e849fa0a1c4057f91c" => :el_capitan
  end

  head do
    url "https://gitlab.cern.ch/CLHEP/CLHEP.git"

    depends_on "automake" => :build
    depends_on "autoconf" => :build
  end

  depends_on "cmake" => :build

  def install
    # CLHEP is super fussy and doesn't allow source tree builds
    dir = Dir.mktmpdir
    cd dir do
      args = std_cmake_args
      if build.stable?
        args << buildpath/"CLHEP"
      else
        args << buildpath
      end
      system "cmake", *args
      system "make", "install"
    end
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <iostream>
      #include <Vector/ThreeVector.h>

      int main() {
        CLHEP::Hep3Vector aVec(1, 2, 3);
        std::cout << "r: " << aVec.mag();
        std::cout << " phi: " << aVec.phi();
        std::cout << " cos(theta): " << aVec.cosTheta() << std::endl;
        return 0;
      }
    EOS
    system ENV.cxx, "-L#{lib}", "-lCLHEP", "-I#{include}/CLHEP",
           testpath/"test.cpp", "-o", "test"
    assert_equal "r: 3.74166 phi: 1.10715 cos(theta): 0.801784",
                 shell_output("./test").chomp
  end
end
