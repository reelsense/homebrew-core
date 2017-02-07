class Proselint < Formula
  include Language::Python::Virtualenv

  desc "Linter for prose"
  homepage "http://proselint.com"
  url "https://files.pythonhosted.org/packages/e6/78/c46f694a0e43ce47d0d6ae089f750131544018dc1119fc7da58ffd4b1e03/proselint-0.7.0.tar.gz"
  sha256 "094d808d44bf1a60dcb1465749be5cc44f4f6c146c04bc5f28976a833786e830"
  head "https://github.com/amperser/proselint.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "687c89e0c258892d4828b56f11b9329a31369a9db73a90c1247ab6bf383da671" => :sierra
    sha256 "933de5180619d51cd5c025b532975f50f8b150d95a805b099662e14825a860a2" => :el_capitan
    sha256 "a98c0d9911557b387cf745985b4928be442eb87d2364f639c9041456349fbd8e" => :yosemite
  end

  depends_on :python if MacOS.version <= :snow_leopard

  resource "click" do
    url "https://files.pythonhosted.org/packages/95/d9/c3336b6b5711c3ab9d1d3a80f1a3e2afeb9d8c02a7166462f6cc96570897/click-6.7.tar.gz"
    sha256 "f15516df478d5a56180fbf80e68f206010e6d160fc39fa508b65e035fd75130b"
  end

  resource "future" do
    url "https://files.pythonhosted.org/packages/00/2b/8d082ddfed935f3608cc61140df6dcbf0edea1bc3ab52fb6c29ae3e81e85/future-0.16.0.tar.gz"
    sha256 "e39ced1ab767b5936646cedba8bcce582398233d6a627067d4c6a454c90cfedb"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/b3/b2/238e2590826bfdd113244a40d9d3eb26918bd798fc187e2360a8367068db/six-1.10.0.tar.gz"
    sha256 "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    output = pipe_output("#{bin}/proselint --compact -", "John is very unique.")
    assert_match /weasel_words\.very.*uncomparables/m, output
  end
end
