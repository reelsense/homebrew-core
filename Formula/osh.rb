class Osh < Formula
  desc "Two ports of /bin/sh from V6 UNIX (circa 1975)"
  homepage "https://v6shell.org/"
  url "https://v6shell.org/src/osh-4.4.0.tar.gz"
  sha256 "65a77c73a92c282159f455e04cc0b4de6bd7e1c3db99405e0cb7fe281fd88e81"
  version_scheme 1
  head "https://github.com/JNeitzel/v6shell.git", :branch => "current"

  bottle do
    sha256 "3981b2b01455ff2f689feb0355ca0f2b8eea7049cf2dd81943d83f8c58bd586a" => :sierra
    sha256 "e4ad8a13f302abac406b9c948965574237afa06a7a9b62c854bfdf6afb4465a8" => :el_capitan
    sha256 "ffba74a1d76e0234e60877c6472f72dceab8c23771cd7b1c04bccff798d6628c" => :yosemite
  end

  option "with-examples", "Build with shell examples"

  resource "examples" do
    url "https://v6shell.org/v6scripts/v6scripts-20160128.tar.gz"
    sha256 "c23251137de67b042067b68f71cd85c3993c566831952af305f1fde93edcaf4d"
  end

  def install
    system "./configure", "osh", "sh6"
    system "make", "install", "PREFIX=#{prefix}", "SYSCONFDIR=#{etc}", "MANDIR=#{man1}"

    if build.with? "examples"
      resource("examples").stage do
        ENV.prepend_path "PATH", bin
        system "./INSTALL", libexec
      end
    end
  end

  test do
    assert_match "brew!", shell_output("#{bin}/osh -c 'echo brew!'").strip

    if build.with? "examples"
      ENV.prepend_path "PATH", libexec
      assert_match "1 3 5 7 9 11 13 15 17 19", shell_output("#{libexec}/counts").strip
    end
  end
end
