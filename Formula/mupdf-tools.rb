class MupdfTools < Formula
  desc "Lightweight PDF and XPS viewer"
  homepage "http://mupdf.com"
  url "http://mupdf.com/downloads/archive/mupdf-1.10a-source.tar.gz"
  sha256 "aacc1f36b9180f562022ef1ab3439b009369d944364f3cff8a2a898834e3a836"
  head "git://git.ghostscript.com/mupdf.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "78c316d6d9abf1c780020ea47400e194c088fe5d169bc24900a57df73df2338a" => :sierra
    sha256 "35827daa262f98d2f8678e8c75efebb90aed82c671a0355e70654b086c98ed5a" => :el_capitan
    sha256 "99172765ae5dc646bae6bd67e6dabd5e7203b30d8d75b68022d3db10a2dc929e" => :yosemite
  end

  depends_on :macos => :snow_leopard

  def install
    system "make", "install",
           "build=release",
           "verbose=yes",
           "HAVE_X11=no",
           "CC=#{ENV.cc}",
           "prefix=#{prefix}"

    # Symlink `mutool` as `mudraw` (a popular shortcut for `mutool draw`).
    bin.install_symlink bin/"mutool" => "mudraw"
    man1.install_symlink man1/"mutool.1" => "mudraw.1"
  end

  test do
    pdf = test_fixtures("test.pdf")
    assert_match "Homebrew test", shell_output("#{bin}/mutool draw -F txt #{pdf}")
  end
end
