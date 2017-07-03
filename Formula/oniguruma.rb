class Oniguruma < Formula
  desc "Regular expressions library"
  homepage "https://github.com/kkos/oniguruma/"
  url "https://github.com/kkos/oniguruma/releases/download/v6.4.0/onig-6.4.0.tar.gz"
  sha256 "cf43ddc5167aea260c4297c76b0dd5e1e6d67aa39319db667347d4d0706ff695"

  bottle do
    cellar :any
    sha256 "218c158da8742bc485b6c9987cd295a5078b239436a914cf51d4d3512c291038" => :sierra
    sha256 "3d0ca070a9ad6ad71013b44639e0c18dcdadef0c468eed2fd410caa36c6bfa47" => :el_capitan
    sha256 "c24ff450ab651e7f93d89582353e0b21328e8709dd1bf1185014b9f27eb2256e" => :yosemite
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match /#{prefix}/, shell_output("#{bin}/onig-config --prefix")
  end
end
