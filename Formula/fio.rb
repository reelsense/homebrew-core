class Fio < Formula
  desc "I/O benchmark and stress test"
  homepage "http://freecode.com/projects/fio"
  url "https://github.com/axboe/fio/archive/fio-2.21.tar.gz"
  sha256 "2d9a14a23cb66086690db4f4cfe07d66f87628378a49d14a4b80798aaee1095e"

  bottle do
    cellar :any_skip_relocation
    sha256 "ffc36b7f3001e3c08067547613fe2d0f8c974fd5145a10e4e268e0034942d35c" => :sierra
    sha256 "91aad2feedb148a4fcfd4eb64369096f7863b22494a8cf756d76aa4503c3194d" => :el_capitan
    sha256 "8e7330af351d0cd5925bdfd7bfbbca71660f6483dc5d552da1858d31615e18a7" => :yosemite
  end

  def install
    system "./configure"
    # fio's CFLAGS passes vital stuff around, and crushing it will break the build
    system "make", "prefix=#{prefix}",
                   "mandir=#{man}",
                   "sharedir=#{share}",
                   "CC=#{ENV.cc}",
                   "V=true", # get normal verbose output from fio's makefile
                   "install"
  end

  test do
    system "#{bin}/fio", "--parse-only"
  end
end
