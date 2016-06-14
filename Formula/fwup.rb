class Fwup < Formula
  desc "Configurable embedded Linux firmware update creator and runner"
  homepage "https://github.com/fhunleth/fwup"
  url "https://github.com/fhunleth/fwup/releases/download/v0.7.0/fwup-0.7.0.tar.gz"
  sha256 "8958c4edf80610c14049b57a44ee7bb9b15676b6ea094a44f87d4187edd393e7"

  bottle do
    cellar :any
    sha256 "3fb33ebe43451d0364d150f096a58df63c7d768c4e43b754217ef21fd0f9b299" => :el_capitan
    sha256 "e8f36718376b3bbadd70120f84a89c0c868bb87e87f3346cc7fee74d14424d3a" => :yosemite
    sha256 "476cbebfbdebde7554fa3484fab668c25f78e7e065948746288ab07870871d61" => :mavericks
  end

  depends_on "confuse"
  depends_on "libarchive"
  depends_on "libsodium"

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make", "install"
  end

  test do
    system "#{bin}/fwup", "-g"
    assert File.exist?("fwup-key.priv")
    assert File.exist?("fwup-key.pub")
  end
end
