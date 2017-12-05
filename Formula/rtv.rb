class Rtv < Formula
  include Language::Python::Virtualenv

  desc "Command-line Reddit client"
  homepage "https://github.com/michael-lazar/rtv"
  url "https://github.com/michael-lazar/rtv/archive/v1.20.0.tar.gz"
  sha256 "a13ab27e3b5bfb2f3f755315dcf2d2d07dd369d1fc3e01bbee2d91e42c89b2ab"
  head "https://github.com/michael-lazar/rtv.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c448a77c2a6f808066e935074d507db8d9d2b03a2e80549f1a1e4476614a7117" => :high_sierra
    sha256 "95f0278819b03896a8e3707cd62ee850d29255aa9279d6ea6ca779fea1362421" => :sierra
    sha256 "2b782d41ee6262bcc43bb20ea7cdaa49b7152e586a72a9065f81666cc91663e2" => :el_capitan
  end

  depends_on :python3

  def install
    venv = virtualenv_create(libexec, "python3")
    system libexec/"bin/pip", "install", "-v", "--no-binary", ":all:",
                              "--ignore-installed", buildpath
    system libexec/"bin/pip", "uninstall", "-y", name
    venv.pip_install_and_link buildpath
  end

  test do
    system "#{bin}/rtv", "--version"
  end
end
