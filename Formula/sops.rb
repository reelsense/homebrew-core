class Sops < Formula
  desc "Editor of encrypted files"
  homepage "https://github.com/mozilla/sops"
  url "https://pypi.python.org/packages/51/f5/f529436dff6af2322288ee753d2b44b443eaf082194275036b1b39b63c8c/sops-1.13.tar.gz"
  sha256 "aeb0213c27d033755acf894fb2c57138843e5d571d0895c708060f7b9fa5adff"

  bottle do
    cellar :any
    sha256 "49f0886bb3d08f33d486ff96f9866a481b53c1b406aa21888897eefdd8a89fe2" => :el_capitan
    sha256 "918b98fc99668c7f8f8641807391fb27f2807b02bdda7ec3983048643db05c96" => :yosemite
    sha256 "b815b520c0b8458146b839d365ecc5017ccb0a80fdb64aad93f6b734f7b82915" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "libyaml"
  depends_on "openssl"
  depends_on :python if MacOS.version <= :snow_leopard

  resource "boto3" do
    url "https://pypi.python.org/packages/source/b/boto3/boto3-1.3.0.tar.gz"
    sha256 "8f85b9261a5b4606d883248a59ef1a4e82fd783602dbec8deac4d2ad36a1b6f4"
  end

  resource "botocore" do
    url "https://pypi.python.org/packages/source/b/botocore/botocore-1.4.11.tar.gz"
    sha256 "96295db1444e9a458a3018205187ec424213e0a69c937062347f88b7b7e078fb"
  end

  resource "cffi" do
    url "https://pypi.python.org/packages/source/c/cffi/cffi-1.5.2.tar.gz"
    sha256 "da9bde99872e46f7bb5cff40a9b1cc08406765efafb583c704de108b6cb821dd"
  end

  resource "cryptography" do
    url "https://pypi.python.org/packages/source/c/cryptography/cryptography-1.3.1.tar.gz"
    sha256 "b4b36175e0f95ddc88435c26dbe3397edce48e2ff5fe41d504cdb3beddcd53e2"
  end

  resource "docutils" do
    url "https://pypi.python.org/packages/source/d/docutils/docutils-0.12.tar.gz"
    sha256 "c7db717810ab6965f66c8cf0398a98c9d8df982da39b4cd7f162911eb89596fa"
  end

  resource "enum34" do
    url "https://pypi.python.org/packages/source/e/enum34/enum34-1.1.3.tar.gz"
    sha256 "865506c22462236b3a2e87a7d9587633e18470e7a93a79b594791de2d31e9bc8"
  end

  resource "futures" do
    url "https://pypi.python.org/packages/source/f/futures/futures-3.0.5.tar.gz"
    sha256 "0542525145d5afc984c88f914a0c85c77527f65946617edb5274f72406f981df"
  end

  resource "idna" do
    url "https://pypi.python.org/packages/source/i/idna/idna-2.1.tar.gz"
    sha256 "ed36f281aebf3cd0797f163bb165d84c31507cedd15928b095b1675e2d04c676"
  end

  resource "ipaddress" do
    url "https://pypi.python.org/packages/source/i/ipaddress/ipaddress-1.0.16.tar.gz"
    sha256 "5a3182b322a706525c46282ca6f064d27a02cffbd449f9f47416f1dc96aa71b0"
  end

  resource "jmespath" do
    url "https://pypi.python.org/packages/source/j/jmespath/jmespath-0.9.0.tar.gz"
    sha256 "08dfaa06d4397f283a01e57089f3360e3b52b5b9da91a70e1fd91e9f0cdd3d3d"
  end

  resource "pyasn1" do
    url "https://pypi.python.org/packages/source/p/pyasn1/pyasn1-0.1.9.tar.gz"
    sha256 "853cacd96d1f701ddd67aa03ecc05f51890135b7262e922710112f12a2ed2a7f"
  end

  resource "pycparser" do
    url "https://pypi.python.org/packages/source/p/pycparser/pycparser-2.14.tar.gz"
    sha256 "7959b4a74abdc27b312fed1c21e6caf9309ce0b29ea86b591fd2e99ecdf27f73"
  end

  resource "python-dateutil" do
    url "https://pypi.python.org/packages/source/p/python-dateutil/python-dateutil-2.5.2.tar.gz"
    sha256 "063907ef47f6e187b8fe0728952e4effb587a34f2dc356888646f9b71fbb2e4b"
  end

  resource "ruamel.ordereddict" do
    url "https://pypi.python.org/packages/source/r/ruamel.ordereddict/ruamel.ordereddict-0.4.9.tar.gz"
    sha256 "7058c470f131487a3039fb9536dda9dd17004a7581bdeeafa836269a36a2b3f6"
  end

  resource "ruamel.yaml" do
    url "https://pypi.python.org/packages/source/r/ruamel.yaml/ruamel.yaml-0.11.9.tar.gz"
    sha256 "4060cdd2aec8b3bf1bbcf6959092fb177897a14e4b8757fafdc7518d9fced2e8"
  end

  resource "setuptools" do
    url "https://pypi.python.org/packages/source/s/setuptools/setuptools-20.8.1.tar.gz"
    sha256 "f49be4963e2d985bf12768f46cbfe4b016787f2c0ed1f8f62c3d2bc0362586da"
  end

  resource "six" do
    url "https://pypi.python.org/packages/source/s/six/six-1.10.0.tar.gz"
    sha256 "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    resources.each do |r|
      r.stage do
        system "python", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    # Namespace packages and .pth files aren't processed from PYTHONPATH.
    touch libexec/"vendor/lib/python2.7/site-packages/ruamel/__init__.py"

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    system "#{bin}/sops", "-v"
  end
end
