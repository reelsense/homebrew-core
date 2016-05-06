class PhoronixTestSuite < Formula
  desc "Automated testing framework"
  homepage "http://www.phoronix-test-suite.com/"
  url "http://www.phoronix-test-suite.com/download.php?file=phoronix-test-suite-5.2.1"
  sha256 "1186f460691e2fe7a07df5edb8d8ed1ac0c65327512e646da2b2e3a60dda6cd9"

  bottle do
    cellar :any_skip_relocation
    sha256 "2821b90bee0c1b736fc7bbf2ddff811f4e0501483ad9958a034a00354c4dc18c" => :el_capitan
    sha256 "992866a9deb933c96c8863efeba613acf2176ce027f82c89de71c050246d2e89" => :yosemite
    sha256 "b1387c352b9fdc9153ce6fac4c8022486370611e2dc62079698d8f7ea635d099" => :mavericks
  end

  patch :DATA

  def install
    system "./install-sh", prefix
  end
end


__END__
--- a/install-sh	2012-01-04 08:43:26.000000000 -0800
+++ b/install-sh	2012-04-23 20:34:21.000000000 -0700
@@ -56,11 +56,11 @@
 mkdir -p $DESTDIR$INSTALL_PREFIX/share/man/man1/
 mkdir -p $DESTDIR$INSTALL_PREFIX/share/phoronix-test-suite/
 mkdir -p $DESTDIR$INSTALL_PREFIX/share/doc/phoronix-test-suite/
-mkdir -p $DESTDIR$INSTALL_PREFIX/../etc/bash_completion.d/
+mkdir -p $DESTDIR$INSTALL_PREFIX/etc/bash_completion.d/
 
-cp CHANGE-LOG $DESTDIR$INSTALL_PREFIX/share/doc/phoronix-test-suite/
-cp COPYING $DESTDIR$INSTALL_PREFIX/share/doc/phoronix-test-suite/
-cp AUTHORS $DESTDIR$INSTALL_PREFIX/share/doc/phoronix-test-suite/
+cp CHANGE-LOG $DESTDIR$INSTALL_PREFIX/CHANGELOG
+cp COPYING $DESTDIR$INSTALL_PREFIX/
+cp AUTHORS $DESTDIR$INSTALL_PREFIX/
 
 cd documentation/
 cp -r * $DESTDIR$INSTALL_PREFIX/share/doc/phoronix-test-suite/
@@ -68,7 +68,7 @@
 rm -rf $DESTDIR$INSTALL_PREFIX/share/doc/phoronix-test-suite/man-pages/
 
 cp documentation/man-pages/*.1 $DESTDIR$INSTALL_PREFIX/share/man/man1/
-cp pts-core/static/bash_completion $DESTDIR$INSTALL_PREFIX/../etc/bash_completion.d/phoronix-test-suite
+cp pts-core/static/bash_completion $DESTDIR$INSTALL_PREFIX/etc/bash_completion.d/phoronix-test-suite.bash
 cp pts-core/static/images/phoronix-test-suite.png $DESTDIR$INSTALL_PREFIX/share/icons/hicolor/48x48/apps/phoronix-test-suite.png
 cp pts-core/static/phoronix-test-suite.desktop $DESTDIR$INSTALL_PREFIX/share/applications/
 cp pts-core/static/phoronix-test-suite-launcher.desktop $DESTDIR$INSTALL_PREFIX/share/applications/
@@ -90,7 +90,7 @@
 # sed 's:\$url = PTS_PATH . \"documentation\/index.html\";:\$url = \"'"$INSTALL_PREFIX"'\/share\/doc\/packages\/phoronix-test-suite\/index.html\";:g' pts-core/commands/gui_gtk.php > $DESTDIR$INSTALL_PREFIX/share/phoronix-test-suite/pts-core/commands/gui_gtk.php
 
 # XDG MIME OpenBenchmarking support
-if [ "X$DESTDIR" = "X" ]
+if [ "X$INSTALL_PREFIX" = "X" ]
 then
 	#No chroot
 	xdg-mime install pts-core/openbenchmarking.org/openbenchmarking-mime.xml
@@ -104,7 +104,7 @@
 
 fi
 
-echo -e "\nPhoronix Test Suite Installation Completed\n
+echo "\nPhoronix Test Suite Installation Completed\n
 Executable File: $INSTALL_PREFIX/bin/phoronix-test-suite
 Documentation: $INSTALL_PREFIX/share/doc/phoronix-test-suite/
 Phoronix Test Suite Files: $INSTALL_PREFIX/share/phoronix-test-suite/\n"
