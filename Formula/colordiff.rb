class Colordiff < Formula
  desc "Color-highlighted diff(1) output"
  homepage "https://www.colordiff.org/"
  url "https://www.colordiff.org/colordiff-1.0.17.tar.gz"
  sha256 "780f70916f6fdc2eccbb519069662de1411705601ba1f1808a7e34f4d987d427"

  bottle do
    cellar :any_skip_relocation
    sha256 "cc4e89679b9cc83ea97edb37a9c1d766ba3273e21087297496567f55b677bb77" => :sierra
    sha256 "46960826668ad5d3ae1ee49afa1ba85da5ba9377b9c5d27393589c588a95a779" => :el_capitan
    sha256 "46960826668ad5d3ae1ee49afa1ba85da5ba9377b9c5d27393589c588a95a779" => :yosemite
  end

  conflicts_with "cdiff", :because => "both install `cdiff` binaries"

  patch :DATA

  def install
    man1.mkpath
    system "make", "INSTALL_DIR=#{bin}",
                   "ETC_DIR=#{etc}",
                   "MAN_DIR=#{man1}",
                   "install"
  end

  test do
    cp HOMEBREW_PREFIX+"bin/brew", "brew1"
    cp HOMEBREW_PREFIX+"bin/brew", "brew2"
    system "#{bin}/colordiff", "brew1", "brew2"
  end
end

__END__
diff --git a/Makefile b/Makefile
index 6ccbfc7..e5d64e7 100644
--- a/Makefile
+++ b/Makefile
@@ -28,8 +29,8 @@ install:
 	if [ ! -f ${DESTDIR}${INSTALL_DIR}/cdiff ] ; then \
 	  install cdiff.sh ${DESTDIR}${INSTALL_DIR}/cdiff; \
 	fi
-	install -Dm 644 colordiff.1 ${DESTDIR}${MAN_DIR}/colordiff.1
-	install -Dm 644 cdiff.1 ${DESTDIR}${MAN_DIR}/cdiff.1
+	install -m 644 colordiff.1 ${DESTDIR}${MAN_DIR}/colordiff.1
+	install -m 644 cdiff.1 ${DESTDIR}${MAN_DIR}/cdiff.1
 	if [ -f ${DESTDIR}${ETC_DIR}/colordiffrc ]; then \
 	  mv -f ${DESTDIR}${ETC_DIR}/colordiffrc \
 	    ${DESTDIR}${ETC_DIR}/colordiffrc.old; \
@@ -37,7 +38,6 @@ install:
 	  install -d ${DESTDIR}${ETC_DIR}; \
 	fi
 	cp colordiffrc ${DESTDIR}${ETC_DIR}/colordiffrc
-	-chown root.root ${DESTDIR}${ETC_DIR}/colordiffrc
 	chmod 644 ${DESTDIR}${ETC_DIR}/colordiffrc

 uninstall:
