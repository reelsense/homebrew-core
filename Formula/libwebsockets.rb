class Libwebsockets < Formula
  desc "C websockets server library"
  homepage "https://libwebsockets.org"
  url "https://github.com/warmcat/libwebsockets/archive/v2.0.1.tar.gz"
  sha256 "f98cf9e35385863cfe64a5f181403bf3113cc5d82604c4811e1373ba8676ef88"
  head "https://github.com/warmcat/libwebsockets.git"

  bottle do
    sha256 "271f9933984c5a042d11b60125087f5100dbc4b6e5288cdce4769598867b1006" => :el_capitan
    sha256 "9a7747886ba26dfbaf9f4996c4ff909680d11e11f8b067a6604213633baf4237" => :yosemite
    sha256 "b73a2f554784b3e45d0c8ebdb6d7ccf914315d2c3f957c80db59ce48178b4917" => :mavericks
  end

  depends_on "cmake" => :build
  depends_on "openssl"

  def install
    system "cmake", ".", *std_cmake_args
    system "make"
    system "make", "install"
  end
end
