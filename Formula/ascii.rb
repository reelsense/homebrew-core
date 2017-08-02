class Ascii < Formula
  desc "List ASCII idiomatic names and octal/decimal code-point forms"
  homepage "http://www.catb.org/~esr/ascii/"

  stable do
    url "http://www.catb.org/~esr/ascii/ascii-3.17.tar.gz"
    sha256 "94e55080fa20168cb9501693d7715869f329a7be1e74de0bd55faa493ee25445"

    # NEWS file is needed for the build but missing from the release tarball
    # Reported 31 Jul 2017 to esr AT thyrsus DOT com
    resource "NEWS" do
      url "http://www.catb.org/~esr/ascii/NEWS"
      sha256 "b743afe2b21f88beb0d0cfb732ed3c4cb646ce37a7017c82f99e8d92149bfd33"
    end
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "ea9d061985b9f11b415b943b1f4ce5aa5528052701911acc0d62a47f0b233e4d" => :sierra
    sha256 "6bf609ef12568dc3e2cc48bccc9414047483ca9f9dccb13493c8b5b462f8fe7b" => :el_capitan
    sha256 "33eda7e9a5da959b27427bd0eca7b27ceca70e4cc3a41e52ff1b0c1fbbcd7cd1" => :yosemite
  end

  head do
    url "git://thyrsus.com/repositories/ascii.git"
    depends_on "xmlto" => :build
  end

  def install
    if build.head?
      ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"
    else
      buildpath.install resource("NEWS")
    end

    bin.mkpath
    man1.mkpath
    system "make"
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    assert_match "Official name: Line Feed", shell_output(bin/"ascii 0x0a")
  end
end
