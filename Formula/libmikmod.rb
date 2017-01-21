class Libmikmod < Formula
  desc "Portable sound library"
  homepage "http://mikmod.shlomifish.org"
  url "https://downloads.sourceforge.net/project/mikmod/libmikmod/3.3.10/libmikmod-3.3.10.tar.gz"
  sha256 "00b3f5298431864ebd069de793ec969cfea3ae6f340f6dfae1ff7da1ae24ef48"

  bottle do
    cellar :any
    sha256 "6920709cbb700e6d6aa429a0989c59e673ad0bcce48deb283eb67c12282d9882" => :sierra
    sha256 "60813dba17815c4f66419754fd6c0897148dcf52ed7f44e1c9ff920631fe1657" => :el_capitan
    sha256 "bd01580da3d41d8d8cebdb77f266508cf30d548d3e34205c99484b7f21749889" => :yosemite
  end

  option "with-debug", "Enable debugging symbols"
  option :universal

  def install
    ENV.O2 if build.with? "debug"
    ENV.universal_binary if build.universal?

    # macOS has CoreAudio, but ALSA is not for this OS nor is SAM9407 nor ULTRA.
    args = %W[
      --prefix=#{prefix}
      --disable-alsa
      --disable-sam9407
      --disable-ultra
    ]
    args << "--with-debug" if build.with? "debug"
    mkdir "macbuild" do
      system "../configure", *args
      system "make", "install"
    end
  end

  test do
    system "#{bin}/libmikmod-config", "--version"
  end
end
