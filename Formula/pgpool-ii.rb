class PgpoolIi < Formula
  desc "PostgreSQL connection pool server"
  homepage "https://www.pgpool.net/mediawiki/index.php/Main_Page"
  url "https://www.pgpool.net/download.php?f=pgpool-II-3.6.7.tar.gz"
  sha256 "09cfe2cb36b9171d4a987a8b100e298e46d6a369c1b61d9e1a47d442ce16e249"

  bottle do
    sha256 "003329039ed94efc5ed99c2ff9c903323fe1061c7d545c791f62836ea1e94bd6" => :high_sierra
    sha256 "ab710a008b3a1692f0773a15bd2a979f31588e64a0647536d273c529b1d700fb" => :sierra
    sha256 "c1590bcbf5b65e0b4f4f0438fbc5f86e5c6c876d971443ade09bdbeeeab05eed" => :el_capitan
  end

  depends_on :postgresql

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}"
    system "make", "install"
  end

  test do
    cp etc/"pgpool.conf.sample", testpath/"pgpool.conf"
    system bin/"pg_md5", "--md5auth", "pool_passwd", "--config-file", "pgpool.conf"
  end
end
