class Libfabric < Formula
  desc "OpenFabrics libfabric"
  homepage "https://ofiwg.github.io/libfabric/"
  url "https://github.com/ofiwg/libfabric/releases/download/v1.5.2/libfabric-1.5.2.tar.bz2"
  sha256 "c05f601e929bc1190683b8e1b06075e6d772196b68f0bbda87827fd08d9e0d6d"
  head "https://github.com/ofiwg/libfabric.git"

  bottle do
    sha256 "73eff6b37ac05aa1b6174453a4019befa474d3714e0b35e2cd18fc63d01cac7d" => :high_sierra
    sha256 "40153ea7be894b3d4ca933bc39fb705c3e3be313de98c97111f305bc4120de2b" => :sierra
    sha256 "3f69a1ce47cc4fa738fe9e057b69f04be7b4602e78ee030d27445cd49e36118e" => :el_capitan
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool"  => :build

  def install
    system "autoreconf", "-fiv"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#(bin}/fi_info"
  end
end
