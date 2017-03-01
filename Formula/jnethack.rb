require "etc"

# Nethack the way God intended it to be played: from a terminal.

# This formula is based on Nethack formula.
# The patches in DATA section are shamelessly stolen from MacPorts' jnethack portfile.

class Jnethack < Formula
  desc "Japanese localization of Nethack"
  homepage "https://jnethack.osdn.jp/"
  url "https://downloads.sourceforge.net/project/nethack/nethack/3.4.3/nethack-343-src.tgz"
  version "3.4.3-0.11"
  sha256 "bb39c3d2a9ee2df4a0c8fdde708fbc63740853a7608d2f4c560b488124866fe4"

  bottle do
    sha256 "89c2fed343614d39084a8c59908032fe929e78c1572e92f50b9eafa4aca3860d" => :sierra
    sha256 "c11837932635f89762360ad449e189c44e8213cb74f981ccb7908671a0e3ad4b" => :el_capitan
    sha256 "f0c7c0c5bbf5c7d5b2d733fd76d49f31039b15c982a7ef7530444f734a41ec7c" => :yosemite
  end

  # needs X11 locale for i18n
  depends_on :x11

  # Don't remove save folder
  skip_clean "libexec/save"

  patch do
    url "http://iij.dl.sourceforge.jp/jnethack/58545/jnethack-3.4.3-0.11.diff.gz"
    sha256 "fbc071f6b33c53d89e8f13319ced952e605499a21d2086077296c631caff7389"
  end

  patch :DATA

  def install
    # Build everything in-order; no multi builds.
    ENV.deparallelize

    ENV["HOMEBREW_CFLAGS"] = ENV.cflags

    # Symlink makefiles
    system "sh", "sys/unix/setup.sh"

    inreplace "include/config.h",
      /^#\s*define HACKDIR.*$/,
      "#define HACKDIR \"#{libexec}\""

    # Enable wizard mode for the current user
    wizard = Etc.getpwuid.name

    inreplace "include/config.h",
      /^#\s*define\s+WIZARD\s+"wizard"/,
      "#define WIZARD \"#{wizard}\""

    inreplace "include/config.h",
      /^#\s*define\s+WIZARD_NAME\s+"wizard"/,
      "#define WIZARD_NAME \"#{wizard}\""

    cd "dat" do
      system "make"

      %w[perm logfile].each do |f|
        touch f
        libexec.install f
      end

      # Stage the data
      libexec.install %w[jhelp jhh jcmdhelp jhistory jopthelp jwizhelp dungeon license data jdata.base joracles options jrumors.tru jrumors.fal quest.dat jquest.txt]
      libexec.install Dir["*.lev"]
    end

    # Make the game
    ENV.append_to_cflags "-I../include"
    cd "src" do
      system "make"
    end

    bin.install "src/jnethack"
    (libexec+"save").mkpath
  end
end

__END__
--- nethack/src/options.c.orig	2006-08-12 16:45:15.000000000 +0900
+++ nethack/src/options.c	2006-08-12 16:45:43.000000000 +0900
@@ -137,7 +137,7 @@
 #else
 	{"news", (boolean *)0, FALSE, SET_IN_FILE},
 #endif
-	{"null", &flags.null, TRUE, SET_IN_GAME},
+	{"null", &flags.null, FALSE, SET_IN_GAME},
 #ifdef MAC
 	{"page_wait", &flags.page_wait, TRUE, SET_IN_GAME},
 #else
--- nethack/sys/unix/Makefile.doc.orig	2006-07-29 05:14:04.000000000 +0900
+++ nethack/sys/unix/Makefile.doc	2006-07-29 05:24:47.000000000 +0900
@@ -40,8 +40,8 @@
 	latex Guidebook.tex
 
 
-GAME	= nethack
-MANDIR	= /usr/local/man/man6
+GAME	= jnethack
+MANDIR	= $(DESTDIR)HOMEBREW_PREFIX/share/man/man6
 MANEXT	= 6
 
 # manual installation for most BSD-style systems
--- nethack/sys/unix/Makefile.src.orig	2008-05-12 09:35:18.000000000 +0900
+++ nethack/sys/unix/Makefile.src	2008-05-12 09:36:38.000000000 +0900
@@ -36,7 +36,7 @@
 # SHELL=E:/GEMINI2/MUPFEL.TTP
 
 # Normally, the C compiler driver is used for linking:
-LINK=$(CC)
+LINK=$(CC) $(CFLAGS)
 
 # Pick the SYSSRC and SYSOBJ lines corresponding to your desired operating
 # system.
@@ -72,7 +72,7 @@
 #
 #	If you are using GCC 2.2.2 or higher on a DPX/2, just use:
 #
-CC = gcc
+#CC = gcc
 #
 #	For HP/UX 10.20 with GCC:
 # CC = gcc -D_POSIX_SOURCE
@@ -154,8 +154,8 @@
 # flags for debugging:
 # CFLAGS = -g -I../include
 
-CFLAGS = -W -g -O -I../include
-LFLAGS = 
+CFLAGS = $(HOMEBREW_CFLAGS) -I../include
+LFLAGS = $(LDFLAGS)
 
 # The Qt and Be window systems are written in C++, while the rest of
 # NetHack is standard C.  If using Qt, uncomment the LINK line here to get
--- nethack/sys/unix/Makefile.top.orig	2006-08-11 13:30:01.000000000 +0900
+++ nethack/sys/unix/Makefile.top	2006-08-11 13:35:41.000000000 +0900
@@ -14,18 +14,18 @@
 # MAKE = make
 
 # make NetHack
-PREFIX	 = /usr
+PREFIX	 = $(DESTDIR)HOMEBREW_PREFIX
 GAME     = jnethack
 # GAME     = nethack.prg
 GAMEUID  = games
-GAMEGRP  = bin
+GAMEGRP  = games
 
 # Permissions - some places use setgid instead of setuid, for instance
 # See also the option "SECURE" in include/config.h
-GAMEPERM = 04755
-FILEPERM = 0644
+GAMEPERM = 02755
+FILEPERM = 0664
 EXEPERM  = 0755
-DIRPERM  = 0755
+DIRPERM  = 0775
 
 # GAMEDIR also appears in config.h as "HACKDIR".
 # VARDIR may also appear in unixconf.h as "VAR_PLAYGROUND" else GAMEDIR
@@ -35,9 +35,9 @@
 # therefore there should not be anything in GAMEDIR that you want to keep
 # (if there is, you'll have to do the installation by hand or modify the
 # instructions)
-GAMEDIR  = $(PREFIX)/games/lib/$(GAME)dir
+GAMEDIR  = $(PREFIX)/share/$(GAME)dir
 VARDIR  = $(GAMEDIR)
-SHELLDIR = $(PREFIX)/games
+SHELLDIR = $(PREFIX)/bin
 
 # per discussion in Install.X11 and Install.Qt
 VARDATND = 
--- nethack/sys/unix/Makefile.utl.orig	2008-05-12 10:17:59.000000000 +0900
+++ nethack/sys/unix/Makefile.utl	2008-05-12 10:19:33.000000000 +0900
@@ -15,7 +15,7 @@
 
 # if you are using gcc as your compiler,
 #	uncomment the CC definition below if it's not in your environment
-CC = gcc
+#CC = gcc
 #
 #	For Bull DPX/2 systems at B.O.S. 2.0 or higher use the following:
 #
@@ -89,8 +89,8 @@
 # flags for debugging:
 # CFLAGS = -g -I../include
 
-CFLAGS = -O -I../include
-LFLAGS =
+CFLAGS = $(HOMEBREW_CFLAGS) -I../include
+LFLAGS = $(LDFLAGS)
 
 LIBS =
  
@@ -276,7 +276,7 @@
 #	dependencies for recover
 #
 recover: $(RECOVOBJS)
-	$(CC) $(LFLAGS) -o recover $(RECOVOBJS) $(LIBS)
+	$(CC) $(CFLAGS) $(LFLAGS) -o recover $(RECOVOBJS) $(LIBS)
 
 recover.o: recover.c $(CONFIG_H) ../include/date.h
 
--- nethack/sys/unix/nethack.sh.orig	2006-08-24 23:23:30.000000000 +0900
+++ nethack/sys/unix/nethack.sh	2006-08-24 23:24:35.000000000 +0900
@@ -5,6 +5,7 @@
 export HACKDIR
 HACK=$HACKDIR/nethack
 MAXNROFPLAYERS=20
+COCOT="HOMEBREW_PREFIX/bin/cocot -t UTF-8 -p EUC-JP"
 
 # JP
 # set LC_ALL, NETHACKOPTIONS etc..
@@ -26,6 +27,10 @@
 	export USERFILESEARCHPATH
 fi
 
+if [ "X$LANG" = "Xja_JP.eucJP" ] ; then
+	COCOT=""
+fi
+
 #if [ "X$DISPLAY" ] ; then
 #	xset fp+ $HACKDIR
 #fi
@@ -84,9 +89,9 @@
 cd $HACKDIR
 case $1 in
 	-s*)
-		exec $HACK "$@"
+		exec $COCOT $HACK "$@"
 		;;
 	*)
-		exec $HACK "$@" $MAXNROFPLAYERS
+		exec $COCOT $HACK "$@" $MAXNROFPLAYERS
 		;;
 esac
--- nethack/win/tty/termcap.c.orig	2006-08-09 19:55:36.000000000 +0900
+++ nethack/win/tty/termcap.c	2006-08-09 20:05:44.000000000 +0900
@@ -861,7 +861,7 @@
 
 #include <curses.h>
 
-#ifndef LINUX
+#if !defined(LINUX) && !defined(__APPLE__)
 extern char *tparm();
 #endif
 
