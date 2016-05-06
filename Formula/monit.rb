class Monit < Formula
  desc "Manage and monitor processes, files, directories, and devices"
  homepage "https://mmonit.com/monit/"
  url "https://mmonit.com/monit/dist/monit-5.17.1.tar.gz"
  mirror "https://mirrors.ocf.berkeley.edu/debian/pool/main//m/monit/monit_5.17.1.orig.tar.gz"
  sha256 "f71a22cfb6bd91ff46496e72e1d1b1021ecd651e7748131ce0f995cc37ff0b42"

  bottle do
    cellar :any
    sha256 "120218d09d1213e8ba666daa5c49b9d706bc03f056c8a456804077cbd899939b" => :el_capitan
    sha256 "4cd021727c8d7b3383cc9a1c9493a076f536aebdbb721e8bc2743920af8b4488" => :yosemite
    sha256 "39ca52d90adbe5004322f1ede9a957c6e5f445b6980a4fe9d24de0e2fb196950" => :mavericks
  end

  depends_on "openssl"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--localstatedir=#{var}/monit",
                          "--sysconfdir=#{etc}/monit",
                          "--with-ssl-dir=#{Formula["openssl"].opt_prefix}"
    system "make", "install"
    pkgshare.install "monitrc"
  end

  test do
    system bin/"monit", "-c", pkgshare/"monitrc", "-t"
  end
end
