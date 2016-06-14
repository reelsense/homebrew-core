class Cdparanoia < Formula
  desc "Audio extraction tool for sampling CDs"
  homepage "https://www.xiph.org/paranoia/"
  url "http://downloads.xiph.org/releases/cdparanoia/cdparanoia-III-10.2.src.tgz"
  sha256 "005db45ef4ee017f5c32ec124f913a0546e77014266c6a1c50df902a55fe64df"

  bottle do
    cellar :any
    sha256 "135250473fe692dc976ecbf7324676fa8cef3cdb48a091287bb183c31548fed9" => :el_capitan
    sha256 "3cd7bbd1a4a0a7992287b255cf0d6409bdb5f4a3fed245b0fd2296e535e9f2de" => :yosemite
    sha256 "14ec797a041edffe73fef897853a833e5588278c03511f27499e55efb68c848d" => :mavericks
  end

  depends_on "autoconf" => :build

  fails_with :llvm do
    build 2326
    cause '"File too small" error while linking'
  end

  # Patches via MacPorts
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/2a22152/cdparanoia/osx_interface.patch"
    sha256 "3eca8ff34d2617c460056f97457b5ac62db1983517525e5c73886a2dea9f06d9"
  end

  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/2a22152/cdparanoia/patch-paranoia_paranoia.c.10.4.diff"
    sha256 "4d6d51909d1b29a3c8ac349f5132a8acd96628355117efb3f192408d2cc4829e"
  end

  def install
    system "autoconf"
    # Libs are installed as keg-only because most software that searches for cdparanoia
    # will fail to link against it cleanly due to our patches
    system "./configure", "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--libdir=#{libexec}"
    system "make", "all"
    system "make", "install"
  end
end
