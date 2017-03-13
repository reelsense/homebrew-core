class Rgbds < Formula
  desc "Rednex GameBoy Development System"
  homepage "https://github.com/rednex/rgbds"
  url "https://github.com/rednex/rgbds/releases/download/v0.2.4/rgbds-0.2.4.tar.gz"
  sha256 "a7d32f369c6acf65fc0875c72873ef21f4d3a5813d3a2ab74ea604429f7f0435"

  head "https://github.com/rednex/rgbds.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ea6db1238c05eba1f3d37c06d55b73119f3dd8d7e8e748191b59fd24f91ad833" => :sierra
    sha256 "46c4d64f4ac330933afec620fb70e469461157d28bd52ddc726ab25de412a3b4" => :el_capitan
    sha256 "2cb8697c3899037e909218ad5b1786116ba1becbe735a68a0efc909e0c0a3478" => :yosemite
    sha256 "c08b856ecf4cb57390ec99241d0bc87ba623536ab7e3e11d5cc23334230ff1cd" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "libpng" => :build

  def install
    system "make", "install", "PREFIX=#{prefix}", "MANPREFIX=#{man}", "PNGFLAGS=-I#{Formula["libpng"].opt_include}"
  end

  test do
    (testpath/"source.asm").write <<-EOS.undent
      SECTION "Org $100",HOME[$100]
      nop
      jp begin
      begin:
        ld sp, $ffff
        ld a, $1
        ld b, a
        add a, b
    EOS
    system "#{bin}/rgbasm", "source.asm"
  end
end
