class Libxc < Formula
  desc "Library of exchange and correlation functionals for codes"
  homepage "http://octopus-code.org/wiki/Libxc"
  url "http://www.tddft.org/programs/octopus/down.php?file=libxc/libxc-3.0.0.tar.gz"
  sha256 "5542b99042c09b2925f2e3700d769cda4fb411b476d446c833ea28c6bfa8792a"

  bottle do
    cellar :any
    sha256 "d96b70198859bdb15e99f5c77de01e4c195bc4a9f88cff692cad8d3abfa88951" => :sierra
    sha256 "226b1ef2d060d2dbce5f178e1edd8f02cc3127b3a782ad51eb3734281fdd3b1f" => :el_capitan
    sha256 "9435141cef17fb02eb91b9d50005ef2a02be5d45017b40155f857ab85d9deca3" => :yosemite
  end

  depends_on :fortran

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--enable-shared",
                          "FCCPP=#{ENV.fc} -E -x c",
                          "CC=#{ENV.cc}",
                          "CFLAGS=-pipe"
    system "make"
    # Disable testsuite, as of 3.0.0 is fails due to upstream issue: http://www.tddft.org/trac/libxc/ticket/22
    # system "make", "check"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <stdio.h>
      #include <xc.h>
      int main()
      {
        int major, minor, micro;
        xc_version(&major, &minor, &micro);
        printf(\"%d.%d.%d\", major, minor, micro);
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lxc", "-I#{include}", "-o", "ctest"
    system "./ctest"

    (testpath/"test.f90").write <<-EOS.undent
      program lxctest
        use xc_f90_types_m
        use xc_f90_lib_m
      end program lxctest
    EOS
    ENV.fortran
    system ENV.fc, "test.f90", "-L#{lib}", "-lxc", "-I#{include}", "-o", "ftest"
    system "./ftest"
  end
end
