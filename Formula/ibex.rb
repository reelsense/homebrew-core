class Ibex < Formula
  desc "C++ library for constraint processing over real numbers."
  homepage "http://www.ibex-lib.org/"
  url "https://github.com/ibex-team/ibex-lib/archive/ibex-2.5.2.tar.gz"
  sha256 "ef8a0988002b9d5f0897696ce434f0eb6170d335f58c0961ccd578eb7f3fc3d3"
  head "https://github.com/ibex-team/ibex-lib.git"

  bottle do
    cellar :any
    sha256 "6b23c61b11e42afa080927febf25c6bde7dbb7f401ccffc66da3f3e5b195e702" => :high_sierra
    sha256 "c0554d687b9f2f0bb9a5bed47fa3e0e72ba269643875351bd46ba292fb125574" => :sierra
    sha256 "9f20ec5533a0a27acff5b9126e2a33492e39f476d37a1e063f9d9bfd02f3ba52" => :el_capitan
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

    if build.with?("java") && build.with?("ampl")
      odie "Cannot set options --with-java and --with-ampl simultaneously for now."
    end

    args = %W[
      --prefix=#{prefix}
      --enable-shared
      --with-optim
      --optim-lib=soplex
    ]

    args << "--with-jni" if build.with? "java"
    args << "--with-ampl" if build.with? "ampl"
    args << "--with-param-estim" if build.with? "param-estim"

    system "./waf", "configure", *args
    system "./waf", "install"

    pkgshare.install %w[examples benchs-solver]
    (pkgshare/"examples/symb01.txt").write <<-EOS.undent
      function f(x)
        return ((2*x,-x);(-x,3*x));
      end
    EOS
  end

  test do
    cp_r (pkgshare/"examples").children, testpath
    cp pkgshare/"benchs-solver/others/cyclohexan3D.bch", testpath/"c3D.bch"

    # so that pkg-config can remain a build-time only dependency
    inreplace %w[makefile slam/makefile] do |s|
      s.gsub! /CXXFLAGS.*pkg-config --cflags ibex./,
              "CXXFLAGS := -I#{include} -I#{include}/ibex "\
                          "-I#{include}/ibex/3rd/coin -I#{include}/ibex/3rd"
      s.gsub! /LIBS.*pkg-config --libs  ibex./, "LIBS := -L#{lib} -libex"
    end

    system "make", "ctc01", "ctc02", "symb01", "solver01", "solver02"
    system "make", "-C", "slam", "slam1", "slam2", "slam3"
    %w[ctc01 ctc02 symb01].each { |a| system "./#{a}" }
    %w[solver01 solver02].each { |a| system "./#{a}", "c3D.bch", "1e-05", "10" }
    %w[slam1 slam2 slam3].each { |a| system "./slam/#{a}" }
  end
end
