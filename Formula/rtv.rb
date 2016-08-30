class Rtv < Formula
  include Language::Python::Virtualenv

  desc "Command-line Reddit client"
  homepage "https://github.com/michael-lazar/rtv"
  url "https://files.pythonhosted.org/packages/49/a0/4d9320a267ff965084dcc02e1b0ec92da4f253a8e01f60ef3f302668295a/rtv-1.12.0.tar.gz"
  sha256 "996221b555f8955b394229d0bd7fc695a5bb75d2a688272ac31ed501e168da69"
  head "https://github.com/michael-lazar/rtv.git"

  bottle do
    sha256 "ddb8cae3f9fb367890144b8e181ee23cb21869a8f11bd67cde1df637c8f60d28" => :el_capitan
    sha256 "b074e6f8d6a471b3d5a3a2bd2c53f184e04a4bf359bc9db5cbfa14dd55e28f36" => :yosemite
    sha256 "9926438d17393dc1943c9f6776c0391cff00b6a6744f3e6985416e3b272c6962" => :mavericks
  end

  depends_on :python3

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/86/ea/8e9fbce5c8405b9614f1fd304f7109d9169a3516a493ce4f7f77c39435b7/beautifulsoup4-4.5.1.tar.gz"
    sha256 "3c9474036afda9136aac6463def733f81017bf9ef3510d25634f335b0c87f5e1"
  end

  resource "decorator" do
    url "https://files.pythonhosted.org/packages/13/8a/4eed41e338e8dcc13ca41c94b142d4d20c0de684ee5065523fee406ce76f/decorator-4.0.10.tar.gz"
    sha256 "9c6e98edcb33499881b86ede07d9968c81ab7c769e28e9af24075f0a5379f070"
  end

  resource "kitchen" do
    url "https://files.pythonhosted.org/packages/d7/17/75c460f30b8f964bd5c1ce54e0280ea3ec8830a7c73a35d5036974245b2f/kitchen-1.2.4.tar.gz"
    sha256 "38f73d844532dba7b8cce170e6eb032fc07d0d04a07670e1af754bd4c91dfb3d"
  end

  resource "mailcap-fix" do
    url "https://files.pythonhosted.org/packages/8c/2a/db1c970c05e65dd8e0ab76d2d3efa3a4b86417d16bc60efc8d8ce075835f/mailcap-fix-0.1.3.tar.gz"
    sha256 "13b33059db4f3d5cd76ed173fb892dd59625075d6ec528e896840db39fb3b436"
  end

  resource "praw" do
    url "https://files.pythonhosted.org/packages/9b/90/2b41c0b374164a9b033093aea7c7f2b392c6333972f83156ab92a3bfbbc4/praw-3.5.0.zip"
    sha256 "0aa3da06d731ed5aa8994f34e46fb36006d168d597ddee216671369917fe8dc3"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/2e/ad/e627446492cc374c284e82381215dcd9a0a87c4f6e90e9789afefe6da0ad/requests-2.11.1.tar.gz"
    sha256 "5acf980358283faba0b897c73959cecf8b841205bb4b2ad3ef545f46eae1a133"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/b3/b2/238e2590826bfdd113244a40d9d3eb26918bd798fc187e2360a8367068db/six-1.10.0.tar.gz"
    sha256 "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a"
  end

  resource "update_checker" do
    url "https://files.pythonhosted.org/packages/ae/06/84e8872337ff2c94a417eef571ac727b1cf2c98355462f7ca239d9eba987/update_checker-0.11.tar.gz"
    sha256 "681bc7c26cffd1564eb6f0f3170d975a31c2a9f2224a32f80fe954232b86f173"
  end

  def install
    virtualenv_create(libexec, "python3")
    virtualenv_install_with_resources
  end

  test do
    system "#{bin}/rtv", "--version"
  end
end
