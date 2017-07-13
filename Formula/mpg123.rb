class Mpg123 < Formula
  desc "MP3 player for Linux and UNIX"
  homepage "https://www.mpg123.de/"
  url "https://www.mpg123.de/download/mpg123-1.25.2.tar.bz2"
  mirror "https://mpg123.orgis.org/download/mpg123-1.25.2.tar.bz2"
  sha256 "5314b0fb8ad291bfc79ff4c5c321b971916819a65233ec065434358fcf8aee38"

  bottle do
    sha256 "47d2df36aab1833709ecc013d4a70adcb13a8a26727cb2a12f634e1256ec4d53" => :sierra
    sha256 "6ba0a4eb846bb874aade35a862e7c2191d0ddd5b7e973f4fca0c752d7bc8db35" => :el_capitan
    sha256 "4eb741a9bcde436c0741b982a26a46f4ad142ad868f4e9d7b2b61a2d4a8f2145" => :yosemite
  end

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --with-default-audio=coreaudio
      --with-module-suffix=.so
    ]

    if MacOS.prefer_64_bit?
      args << "--with-cpu=x86-64"
    else
      args << "--with-cpu=sse_alone"
    end

    system "./configure", *args
    system "make", "install"
  end

  test do
    system bin/"mpg123", "--test", test_fixtures("test.mp3")
  end
end
