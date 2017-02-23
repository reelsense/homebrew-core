class Osc < Formula
  include Language::Python::Virtualenv

  desc "The Command Line Interface to work with an Open Build Service"
  homepage "https://github.com/openSUSE/osc"
  url "https://github.com/openSUSE/osc/archive/0.155.1.tar.gz"
  sha256 "bd392cf601fade0770e2b1fef2a964dfaa02ee002a615708f230549708f26acc"
  head "https://github.com/openSUSE/osc.git"
  revision 1

  bottle do
    cellar :any
    sha256 "51247f4ee5b8dc607b37a0a8dd153473d71cdf68476402e338f21bfdeb433a5e" => :sierra
    sha256 "dfcc29e38cc4033fcbe3520ecf58f1da75e62c8eb86e92155ebb9c5e034649ce" => :el_capitan
    sha256 "de8da7afe2fd2fdd9885a45a33bfaf575c24f313db46830a555d054db8b52c59" => :yosemite
  end

  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "swig" => :build
  depends_on "curl"
  depends_on "openssl" # For M2Crypto

  resource "pycurl" do
    url "https://files.pythonhosted.org/packages/12/3f/557356b60d8e59a1cce62ffc07ecc03e4f8a202c86adae34d895826281fb/pycurl-7.43.0.tar.gz"
    sha256 "aa975c19b79b6aa6c0518c0cc2ae33528900478f0b500531dbcdbf05beec584c"
  end

  resource "urlgrabber" do
    url "https://files.pythonhosted.org/packages/3c/fd/710150d9647e32f1eafe9d60ff55553a8754e185c791781da0246c7d6b57/urlgrabber-3.9.1.tar.gz"
    sha256 "b4e276fa968c66671309a6d754c4b3b0cb2003dec8bca87a681378a22e0d3da7"
  end

  resource "M2Crypto" do
    url "https://files.pythonhosted.org/packages/9c/58/7e8d8c04995a422c3744929721941c400af0a2a8b8633f129d92f313cfb8/M2Crypto-0.25.1.tar.gz"
    sha256 "ac303a1881307a51c85ee8b1d87844d9866ee823b4fdbc52f7e79187c2d9acef"
  end

  def install
    venv = virtualenv_create(libexec)
    venv.pip_install resources.reject { |r| r.name == "M2Crypto" }
    resource("M2Crypto").stage do
      inreplace "setup.py", %r{(self.openssl = )'/usr'}, "\\1'#{Formula["openssl"].prefix}'"
      venv.pip_install "."
    end

    inreplace "osc/conf.py", "'/etc/ssl/certs'", "'#{etc}/openssl/cert.pem'"
    venv.pip_install_and_link buildpath
    mv bin/"osc-wrapper.py", bin/"osc"
  end

  test do
    system bin/"osc", "--version"
  end
end
