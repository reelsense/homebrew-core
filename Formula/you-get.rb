class YouGet < Formula
  include Language::Python::Virtualenv

  desc "Dumb downloader that scrapes the web"
  homepage "https://you-get.org/"
  url "https://github.com/soimort/you-get/releases/download/v0.4.775/you-get-0.4.775.tar.gz"
  sha256 "2f0461c607f41cc106f6810e1d3414d511d6a7470c8843004a99b54b024e9df0"
  head "https://github.com/soimort/you-get.git", :branch => "develop"

  bottle do
    cellar :any_skip_relocation
    sha256 "de83cf1c817a12fb1556a0328234d490a561b2881e6c861970dc1714145c8f19" => :sierra
    sha256 "58d6406e573bcd442e62bf9969909fdd638317dc4ee64724e5bad6c6c88cce19" => :el_capitan
    sha256 "6ad43de56ac6c650d630d55af12b218c4c725328348563db76ae3c581486705a" => :yosemite
  end

  depends_on :python3

  depends_on "rtmpdump" => :optional

  def install
    virtualenv_install_with_resources
  end

  def caveats
    "To use post-processing options, `brew install ffmpeg` or `brew install libav`."
  end

  test do
    system bin/"you-get", "--info", "https://youtu.be/he2a4xK8ctk"
  end
end
