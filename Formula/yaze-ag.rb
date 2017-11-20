class YazeAg < Formula
  desc "Yet Another Z80 Emulator (by AG)"
  homepage "http://www.mathematik.uni-ulm.de/users/ag/yaze-ag/"
  url "http://www.mathematik.uni-ulm.de/users/ag/yaze-ag/devel/yaze-ag-2.30.3.tar.gz"
  sha256 "f63c29a07ed7c17d8159ffe947d95d432147d7d6fad5d04b6fb75f341de121e6"

  bottle do
    sha256 "5a7cb2f9fe6c900a557786f8026c47a75272bf71bc74f1fbedf2c2648c17db0c" => :high_sierra
    sha256 "bee2b2a896191528e71c1d986ecf4ca2fb3923f27617715542137d618584ea55" => :sierra
    sha256 "97ffe6edc70a797cbb26d9399f49b46570b80b705a5d52a0b4fded357bc317ed" => :el_capitan
  end

  # Fix missing sys header include for caddr_t on Mac OS
  # Fix omission of creating bin directory by custom Makefile
  # Upstream author is aware of this issue:
  # https://github.com/Homebrew/homebrew/pull/16817
  patch :DATA

  def install
    system "make", "-f", "Makefile_solaris_gcc",
                   "BINDIR=#{bin}",
                   "MANDIR=#{man1}",
                   "LIBDIR=#{lib}/yaze",
                   "install"
  end

  test do
    (testpath/"cpm").mkpath
    assert_match "yazerc", shell_output("#{bin}/yaze -v", 1)
  end
end

__END__
diff --git a/Makefile_solaris_gcc b/Makefile_solaris_gcc
index 9e469a3..b25d007 100644
--- a/Makefile_solaris_gcc
+++ b/Makefile_solaris_gcc
@@ -140,11 +140,14 @@ simz80.c:	simz80.pl
		perl -w simz80.pl >simz80.c
		chmod a-w simz80.c

+cdm.o:		CFLAGS+=-include sys/types.h
+
 cdm:		cdm.o
		$(CC) $(CFLAGS) cdm.o $(LIBS) -o $@

 install:	all
		rm -rf $(LIBDIR)
+		mkdir -p $(BINDIR)
		mkdir -p $(LIBDIR)
		mkdir -p $(MANDIR)
		$(INSTALL) -s -c -m 755 yaze_bin $(BINDIR)
