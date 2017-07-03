class Treefrog < Formula
  desc "High-speed C++ MVC Framework for Web Application"
  homepage "http://www.treefrogframework.org/"
  url "https://github.com/treefrogframework/treefrog-framework/archive/v1.18.0.tar.gz"
  sha256 "9d9c60c9b36a4a76ac89adcdf1bf3c9a7135f89774332087b34f27e8fc89e0ca"
  head "https://github.com/treefrogframework/treefrog-framework.git"

  bottle do
    sha256 "521573c0bb1696d212152971f66ea300befd4772843edb56191d669317a750a6" => :sierra
    sha256 "502cb26815eece3a32a7bc652b3cde1bbe10aa26da320f388e18f0d30ea3abbf" => :el_capitan
  end

  deprecated_option "with-qt5" => "with-qt"

  option "with-mysql", "enable --with-mysql option for Qt build"
  option "with-postgresql", "enable --with-postgresql option for Qt build"
  option "with-qt", "build and link with QtGui module"

  depends_on :macos => :el_capitan
  depends_on :xcode => [:build, "8.0"]

  qt_build_options = []
  qt_build_options << "with-mysql" if build.with?("mysql")
  qt_build_options << "with-postgresql" if build.with?("postgresql")
  depends_on "qt" => qt_build_options

  def install
    args = ["--prefix=#{prefix}"]
    args << "--enable-gui-mod" if build.with? "qt"

    system "./configure", *args

    cd "src" do
      system "make"
      system "make", "install"
    end

    cd "tools" do
      system "make"
      system "make", "install"
    end
  end

  test do
    system bin/"tspawn", "new", "hello"
    assert File.exist?("hello")
    cd "hello" do
      assert File.exist?("hello.pro")
      system HOMEBREW_PREFIX/"opt/qt/bin/qmake"
      assert File.exist?("Makefile")
      system "make"
      system bin/"treefrog", "-v"
    end
  end
end
