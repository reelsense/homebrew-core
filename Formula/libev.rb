class Libev < Formula
  desc "Asynchronous event library"
  homepage "http://software.schmorp.de/pkg/libev.html"
  url "http://dist.schmorp.de/libev/Attic/libev-4.24.tar.gz"
  sha256 "973593d3479abdf657674a55afe5f78624b0e440614e2b8cb3a07f16d4d7f821"

  bottle do
    cellar :any
    sha256 "f9eace710427fcb1d9c3e821da0ecab3d5ff60e3a00750a7bfd4b17fd3d3d872" => :sierra
    sha256 "3ff3f21def203c8a3d6175b659aa20cb6ed4bcdb8f6922087b4ec9c568e67c75" => :el_capitan
    sha256 "6a41433542500be7a4fc7c350494839add102a73e2c66ef7578c91c73036985b" => :yosemite
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"

    # Remove compatibility header to prevent conflict with libevent
    (include/"event.h").unlink
  end
end
