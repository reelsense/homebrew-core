class Lftp < Formula
  desc "Sophisticated file transfer program"
  homepage "https://lftp.tech"
  url "https://lftp.yar.ru/ftp/lftp-4.7.5.tar.bz2"
  mirror "ftp://ftp.st.ryukoku.ac.jp/pub/network/ftp/lftp/lftp-4.7.5.tar.bz2"
  sha256 "90f3cbc827534c3b3a391a2dd8b39cc981ac4991fa24b6f90e2008ccc0a5207d"

  bottle do
    rebuild 1
    sha256 "5165aa213ad8474a8bc4a53a1b8373809f95a10496291c4eb16c1949632ff93b" => :sierra
    sha256 "4699e621b243e4af23b6bfde52365e6584321f5cb70b57218b27130f13fdf14e" => :el_capitan
    sha256 "2a1e047fb1dbc8ca8da1269e28ea3aa869848f7c6da76aea17dde80d9138992e" => :yosemite
  end

  depends_on "readline"
  depends_on "openssl"
  depends_on "libidn"

  # Fix a cast issue, patch was merged upstream: https://github.com/lavv17/lftp/pull/307
  # Remove when lftp-4.7.6 is released
  patch do
    url "https://github.com/lavv17/lftp/commit/259d642e1fea2ddf38763d49e8e7701f0a947d4c.diff"
    sha256 "729e9d8e2759e79d2f2a07564dc740dada37870cd8bd7065b322bf827138d2c5"
  end

  def install
    # Fix "error: use of undeclared identifier 'SSL_OP_NO_TLSv1_1'"
    # Reported 6 Feb 2017 https://github.com/lavv17/lftp/issues/317
    # Equivalent to upstream PR from 14 Feb 2017 https://github.com/lavv17/lftp/pull/321
    inreplace "src/Makefile.in", "$(ZLIB_CPPFLAGS) $(OPENSSL_CPPFLAGS)",
                                 "$(OPENSSL_CPPFLAGS) $(ZLIB_CPPFLAGS)"

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-openssl=#{Formula["openssl"].opt_prefix}",
                          "--with-readline=#{Formula["readline"].opt_prefix}",
                          "--with-libidn=#{Formula["libidn"].opt_prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/lftp", "-c", "open ftp://ftp.gnu.org/; ls"
  end
end
