class Mandoc < Formula
  desc "The mandoc UNIX manpage compiler toolset"
  homepage "http://mdocml.bsd.lv"
  url "http://mdocml.bsd.lv/snapshots/mdocml-1.13.4.tar.gz"
  sha256 "0a55c1addb188071d6f784599303656b8465e98ec6b2f4f264e12fb96d79e0ef"

  head "anoncvs@mdocml.bsd.lv:/cvs", :module => "mdocml", :using => :cvs

  bottle do
    sha256 "42f275d193a546595d71172c3c3d53e089e36f760724e9a3e4319e7555f76592" => :sierra
    sha256 "98b708b8a2b82a07295e6e5d8165c9c3a1fe91698073549709bf7706a1104435" => :el_capitan
    sha256 "5c90ada1b81b9c9da0cd3507c20667287e5b96268e75328c173bd94e85c6f722" => :yosemite
  end

  option "without-sqlite", "Only install the mandoc/demandoc utilities."
  option "without-cgi", "Don't build man.cgi (and extra CSS files)."

  depends_on "sqlite" => :recommended

  def install
    localconfig = [

      # Sane prefixes.
      "PREFIX=#{prefix}",
      "INCLUDEDIR=#{include}",
      "LIBDIR=#{lib}",
      "MANDIR=#{man}",
      "WWWPREFIX=#{prefix}/var/www",
      "EXAMPLEDIR=#{share}/examples",

      # Executable names, where utilities would be replaced/duplicated.
      # The mdocml versions of the utilities are definitely *not* ready
      # for prime-time on Darwin, though some changes in HEAD are promising.
      # The "bsd" prefix (like bsdtar, bsdmake) is more informative than "m".
      "BINM_MAN=bsdman",
      "BINM_APROPOS=bsdapropos",
      "BINM_WHATIS=bsdwhatis",
      "BINM_MAKEWHATIS=bsdmakewhatis",	# default is "makewhatis".

      # These are names for *section 7* pages only. Several other pages are
      # prefixed "mandoc_", similar to the "groff_" pages.
      "MANM_MAN=man",
      "MANM_MDOC=mdoc",
      "MANM_ROFF=mandoc_roff", # This is the only one that conflicts (groff).
      "MANM_EQN=eqn",
      "MANM_TBL=tbl",

      "OSNAME='Mac OS X #{MacOS.version}'", # Bottom corner signature line.

      # Not quite sure what to do here. The default ("/usr/share", etc.) needs
      # sudoer privileges, or will error. So just brew's manpages for now?
      "MANPATH_DEFAULT=#{HOMEBREW_PREFIX}/share/man",

      "HAVE_MANPATH=0",   # Our `manpath` is a symlink to system `man`.
      "STATIC=",          # No static linking on Darwin.

      "HOMEBREWDIR=#{HOMEBREW_CELLAR}" # ? See configure.local.example, NEWS.
    ]

    localconfig << "BUILD_DB=1" if build.with? "db"
    localconfig << "BUILD_CGI=1" if build.with? "cgi"
    File.rename("cgi.h.example", "cgi.h") # For man.cgi, harmless in any case.

    (buildpath/"configure.local").write localconfig.join("\n")
    system "./configure"

    # I've tried twice to send a bug report on this to tech@mdocml.bsd.lv.
    # In theory, it should show up with:
    # search.gmane.org/?query=jobserver&group=gmane.comp.tools.mdocml.devel
    ENV.deparallelize do
      system "make"
      system "make", "install"
    end

    system "make", "manpage" # Left out of the install for some reason.
    bin.install "manpage"
  end

  test do
    system "#{bin}/mandoc", "-Thtml",
      "-Ostyle=#{share}/examples/example.style.css",
      "#{HOMEBREW_PREFIX}/share/man/man1/brew.1"
  end
end
