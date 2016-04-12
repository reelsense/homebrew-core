class Lnav < Formula
  desc "Curses-based tool for viewing and analyzing log files"
  homepage "http://lnav.org"
  url "https://github.com/tstack/lnav/releases/download/v0.8.0/lnav-0.8.0.tar.gz"
  sha256 "fbebe3f4656c89b307fe06e7746e6146ae856048413a7cd98aaf8fc2bb34fc33"

  bottle do
    revision 2
    sha256 "d34926a00d4aca2e8045ddbe12b948042b2dfa262e403b67f303cfb01c7af482" => :el_capitan
    sha256 "ab14e46f5a4c0570a3437ae1703ec152e86d57e5a47192d3f81d74665e74649d" => :yosemite
    sha256 "457250f40c4f012722c23b23beed1ab8eaee7dda2184581bbec66ad981c270f7" => :mavericks
  end

  head do
    url "https://github.com/tstack/lnav.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "re2c" => :build
  end

  depends_on "readline"
  depends_on "pcre"
  depends_on "curl" => ["with-libssh2", :optional]

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --with-readline=#{Formula["readline"].opt_prefix}
    ]

    # OS X ships with libcurl by default, albeit without sftp support. If we
    # want lnav to use the keg-only curl formula that we specify as a
    # dependency, we need to pass in the path.
    args << "--with-libcurl=#{Formula["curl"].opt_lib}" if build.with? "curl"

    system "./autogen.sh" if build.head?
    system "./configure", *args
    system "make", "install"
  end
end
