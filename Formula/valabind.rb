class Valabind < Formula
  desc "Vala bindings for radare, reverse engineering framework"
  homepage "https://radare.org/"
  revision 4

  head "https://github.com/radare/valabind.git"

  stable do
    url "https://www.radare.org/get/valabind-0.10.0.tar.gz"
    sha256 "35517455b4869138328513aa24518b46debca67cf969f227336af264b8811c19"
    # patch necessary to support vala 0.36.0
    # remove upon next release
    patch do
      url "https://github.com/radare/valabind/commit/f23ff9421c1875d18b1e558596557009b45faa19.patch?full_index=1"
      sha256 "d76e5fffaa209468619d5db36f3f8dad89480c1b74d3d2b14b14fa029d2c4234"
    end

    # patch to support BSD sed
    # remove upon next release
    patch do
      url "https://github.com/radare/valabind/commit/03762a0fca7ff4bbfe3e668f70bb75422e05ac07.patch?full_index=1"
      sha256 "2d9eb2c9c1b64327bc444fc3fc94f7ef284535d9cf28d9ecf887859b253426b3"
    end
  end

  bottle do
    cellar :any
    sha256 "43ebff45cdbe8c7f8fcc098e65b37e07356e3f2889cd9ca674d90c7640d34cfa" => :sierra
    sha256 "aa97b62c200bbf957d1e312bbd99f8f2100addbd43076b1a385c7e24321f6f9c" => :el_capitan
    sha256 "b916fc236518c29a64f7f86e7b0be611564532ab21855822be966107e52d8103" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "swig" => :run
  depends_on "vala"

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system bin/"valabind", "--help"
  end
end
