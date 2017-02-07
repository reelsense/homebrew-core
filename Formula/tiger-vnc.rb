class TigerVnc < Formula
  desc "High-performance, platform-neutral implementation of VNC"
  homepage "http://tigervnc.org/"
  url "https://github.com/TigerVNC/tigervnc/archive/v1.7.1.tar.gz"
  sha256 "3c021ec0bee4611020c0bcbab995b0ef2f6f1a46127a52b368827f3275527ccc"

  bottle do
    sha256 "da4b58cfb0117ac7f2c4a81cba70bb653f8404d6bc8ff02e5320e05f02904ebb" => :sierra
    sha256 "ffeabdeebdeadb9837915070a9730a93fb5bfc8bd69dd8719e2c15d6eb103e64" => :el_capitan
    sha256 "a719884736ffa0fa5ecf99bda2df2afde53897cb08115399a729fbe73a38513a" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "gnutls" => :recommended
  depends_on "jpeg-turbo"
  depends_on "gettext"
  depends_on "fltk"
  depends_on :x11

  # reduce thread stack size to avoid crash
  patch do
    url "https://github.com/TigerVNC/tigervnc/commit/1349e42e395a0a88b67447580d526daf31dba591.diff"
    sha256 "e7321146c7ab752279423c9fc0ee1414eed8f1dc81afd2ea963a7f2d115a7a79"
  end

  def install
    turbo = Formula["jpeg-turbo"]
    args = std_cmake_args + %W[
      -DJPEG_INCLUDE_DIR=#{turbo.include}
      -DJPEG_LIBRARY=#{turbo.lib}/libjpeg.dylib
      .
    ]
    system "cmake", *args
    system "make", "install"
  end
end
