class Itstool < Formula
  desc "Make XML documents translatable through PO files"
  homepage "http://itstool.org/"
  url "http://files.itstool.org/itstool/itstool-2.0.2.tar.bz2"
  sha256 "bf909fb59b11a646681a8534d5700fec99be83bb2c57badf8c1844512227033a"
  revision 2

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "57f0c56db4668c2dbc8aa42fcbbe9e7d28e232ce136e6b0422bc3f270de5cbcf" => :sierra
    sha256 "c8a0dbd869f856272f94b1f855fe61e916ed842bb7eadcf6b18af86432b20e8e" => :el_capitan
    sha256 "c8a0dbd869f856272f94b1f855fe61e916ed842bb7eadcf6b18af86432b20e8e" => :yosemite
  end

  head do
    url "https://github.com/itstool/itstool.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "libxml2"

  def install
    ENV.append_path "PYTHONPATH", "#{Formula["libxml2"].opt_lib}/python2.7/site-packages"

    system "./autogen.sh" if build.head?
    system "./configure", "--prefix=#{libexec}"
    system "make", "install"

    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
    pkgshare.install_symlink libexec/"share/itstool/its"
    man1.install_symlink libexec/"share/man/man1/itstool.1"
  end

  test do
    (testpath/"test.xml").write <<-EOS.undent
      <tag>Homebrew</tag>
    EOS
    system bin/"itstool", "-o", "test.pot", "test.xml"
    assert_match "msgid \"Homebrew\"", File.read("test.pot")
  end
end
