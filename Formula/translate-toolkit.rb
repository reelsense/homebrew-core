class TranslateToolkit < Formula
  include Language::Python::Virtualenv

  desc "Toolkit for localization engineers"
  homepage "http://toolkit.translatehouse.org/"
  url "https://github.com/translate/translate/releases/download/2.0.0/translate-toolkit-2.0.0.tar.bz2"
  sha256 "978f9e150edcc99a301139226b5b283fd6ed83bedaee0dc3a821bcaecdf18898"
  head "https://github.com/translate/translate.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "568389806896ea7cbc1334c010323336b2a3c36932282f5ee1abfa91c3b6f325" => :sierra
    sha256 "4261cf1a99ef85030baa94e67259e3a50392f6d0afc7c7d8a9afcd36fe9a1a19" => :el_capitan
    sha256 "167f71cf955a1e7e936b99c058be14612738ac554ad60fed68146d34ab3c64a9" => :yosemite
  end

  depends_on :python if MacOS.version <= :snow_leopard

  resource "argparse" do
    url "https://files.pythonhosted.org/packages/18/dd/e617cfc3f6210ae183374cd9f6a26b20514bbb5a792af97949c5aacddf0f/argparse-1.4.0.tar.gz"
    sha256 "62b089a55be1d8949cd2bc7e0df0bddb9e028faefc8c32038cc84862aefdd6e4"
  end

  resource "diff-match-patch" do
    url "https://files.pythonhosted.org/packages/22/82/46eaeab04805b4fac17630b59f30c4f2c8860988bcefd730ff4f1992908b/diff-match-patch-20121119.tar.gz"
    sha256 "9dba5611fbf27893347349fd51cc1911cb403682a7163373adacc565d11e2e4c"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/b3/b2/238e2590826bfdd113244a40d9d3eb26918bd798fc187e2360a8367068db/six-1.10.0.tar.gz"
    sha256 "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"pretranslate", "-h"
  end
end
