class Xonsh < Formula
  include Language::Python::Virtualenv

  desc "Python-ish, BASHwards-compatible shell language and command prompt"
  homepage "http://xon.sh"
  url "https://github.com/xonsh/xonsh/archive/0.5.8.tar.gz"
  sha256 "bf5632ce1132616778d2821d660dc6508ecbb93c65da80640d08f6b9ddc87ed9"
  head "https://github.com/scopatz/xonsh.git"

  bottle do
    sha256 "b3453f6b5469523eb3bb7ef566b1a858ea4d93d1ac695d0aa94021ba4a79415e" => :sierra
    sha256 "f33a600f051925edac4627c724d2659de131af17ee36d52b4580b106a336b449" => :el_capitan
    sha256 "5ac056e5d1c959584584f5755a0577d8d403df9eecc8ece4f0dfa936148ccf21" => :yosemite
  end

  depends_on :python3

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "4", shell_output("#{bin}/xonsh -c 2+2")
  end
end
