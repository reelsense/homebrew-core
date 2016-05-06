class Perl < Formula
  desc "Highly capable, feature-rich programming language"
  homepage "https://www.perl.org/"
  url "http://www.cpan.org/src/5.0/perl-5.22.1.tar.xz"
  mirror "https://mirrors.ocf.berkeley.edu/debian/pool/main/p/perl/perl_5.22.1.orig.tar.xz"
  sha256 "9e87317d693ce828095204be0d09af8d60b8785533fadea1a82b6f0e071e5c79"
  revision 1

  head "https://perl5.git.perl.org/perl.git", :branch => "blead"

  bottle do
    sha256 "0e2be2de0d24806763d6f6f97c1686bea9cd753a04709af63816f6ce74beae15" => :el_capitan
    sha256 "410801e02a37ca7d63ec3af56f84a56c271d911477731bcccc26f9dae7ccc697" => :yosemite
    sha256 "6d595837aa06cb8c1d4e878efbb3b2d6ca5ca1f1e0045dfb8c672c12f8c177f9" => :mavericks
  end

  option "with-dtrace", "Build with DTrace probes"
  option "without-test", "Skip running the build test suite"

  deprecated_option "with-tests" => "with-test"

  def install
    args = %W[
      -des
      -Dprefix=#{prefix}
      -Dman1dir=#{man1}
      -Dman3dir=#{man3}
      -Duseshrplib
      -Duselargefiles
      -Dusethreads
    ]

    args << "-Dusedtrace" if build.with? "dtrace"
    args << "-Dusedevel" if build.head?

    system "./Configure", *args
    system "make"

    # OS X El Capitan's SIP feature prevents DYLD_LIBRARY_PATH from being
    # passed to child processes, which causes the make test step to fail.
    # https://rt.perl.org/Ticket/Display.html?id=126706
    # https://github.com/Homebrew/homebrew/issues/41716
    if MacOS.version < :el_capitan
      system "make", "test" if build.with? "test"
    end

    system "make", "install"
  end

  def caveats; <<-EOS.undent
    By default Perl installs modules in your HOME dir. If this is an issue run:
      `#{opt_bin}/cpan o conf init`
    EOS
  end

  test do
    (testpath/"test.pl").write "print 'Perl is not an acronym, but JAPH is a Perl acronym!';"
    system "#{bin}/perl", "test.pl"
  end
end
