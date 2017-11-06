class Ibex < Formula
  desc "C++ library for constraint processing over real numbers"
  homepage "http://www.ibex-lib.org/"
  url "https://github.com/ibex-team/ibex-lib/archive/ibex-2.6.2.tar.gz"
  sha256 "2d2a5e746825c21cc6284df9c24f1cbb7f9903a745b3f5f87515140c43311c61"
  head "https://github.com/ibex-team/ibex-lib.git"

  bottle do
    cellar :any
    sha256 "2ea5ed4839a0ff0afca3aa40186ffddf1aa93ef6f1320d79bd18a84686f369c1" => :high_sierra
    sha256 "c95514baf8f01276312f4efd94ee7991ddcbaa85ad490994f56bc3087b7a347e" => :sierra
    sha256 "75c15a91ac8f8cbcc9425bf2b23ffdf283bb121dc3c685ed8aa8ddd50a2d8121" => :el_capitan
  end

  option "with-java", "Enable Java bindings for CHOCO solver."
  option "with-ampl", "Use AMPL file loader plugin"
  option "without-ensta-robotics", "Don't build the Contractors for robotics (SLAM) plugin"

  depends_on :java => ["1.8+", :optional]
  depends_on "bison" => :build
  depends_on "flex" => :build
  depends_on "pkg-config" => :build

  needs :cxx11

  def install
    ENV.cxx11

    # Reported 9 Oct 2017 https://github.com/ibex-team/ibex-lib/issues/286
    ENV.deparallelize

    if build.with?("java") && build.with?("ampl")
      odie "Cannot set options --with-java and --with-ampl simultaneously for now."
    end

    args = %W[
      --prefix=#{prefix}
      --enable-shared
      --with-optim
      --lp-lib=soplex
    ]

    args << "--with-jni" if build.with? "java"
    args << "--with-ampl" if build.with? "ampl"
    args << "--with-param-estim" if build.with? "param-estim"

    system "./waf", "configure", *args
    system "./waf", "install"

    pkgshare.install %w[examples plugins/solver/benchs]
    (pkgshare/"examples/symb01.txt").write <<~EOS
      function f(x)
        return ((2*x,-x);(-x,3*x));
      end
    EOS
  end

  test do
    cp_r (pkgshare/"examples").children, testpath

    # so that pkg-config can remain a build-time only dependency
    inreplace %w[makefile slam/makefile] do |s|
      s.gsub! /CXXFLAGS.*pkg-config --cflags ibex./,
              "CXXFLAGS := -I#{include} -I#{include}/ibex "\
                          "-I#{include}/ibex/3rd"
      s.gsub! /LIBS.*pkg-config --libs  ibex./, "LIBS := -L#{lib} -libex"
    end

    system "make", "lab1", "lab2", "lab3", "lab4"
    system "make", "-C", "slam", "slam1", "slam2", "slam3"
    %w[lab1 lab2 lab3 lab4].each { |a| system "./#{a}" }
    system "./slam/slam3"
  end
end
