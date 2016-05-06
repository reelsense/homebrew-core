class Ttf2eot < Formula
  desc "Convert TTF files to EOT"
  homepage "https://code.google.com/p/ttf2eot/"
  url "https://ttf2eot.googlecode.com/files/ttf2eot-0.0.2-2.tar.gz"
  sha256 "023cf04d7c717657e92afe566518bf2a696ab22a2a8eba764340000bebff8db8"

  bottle do
    cellar :any_skip_relocation
    sha256 "e6d90a726548a3321d33135538390ff4bcfda18faf01f97fdea6e3dbd2dee165" => :el_capitan
    sha256 "e0c767aefbe0c95c28c07efdd63a86fb397e0bcb6b42173ff6792ec216aa063f" => :yosemite
    sha256 "8091c9f2a8b3c75c28d4f646ef15e42d6a205e5beeea19d72dc2883623dc5cd6" => :mavericks
  end

  def install
    system "make"
    bin.install "ttf2eot"
  end
end
