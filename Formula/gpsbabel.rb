class Gpsbabel < Formula
  desc "Converts/uploads GPS waypoints, tracks, and routes"
  homepage "https://www.gpsbabel.org/"
  url "https://github.com/gpsbabel/gpsbabel/archive/gpsbabel_1_5_4.tar.gz"
  sha256 "8cd740db0b92610abff71e942e8a987df58cd6ca5f25cca86e15f2b00e190704"
  head "https://github.com/gpsbabel/gpsbabel.git"

  bottle do
    sha256 "573d8ca5e3785f8f5b02b148c63fcaa59d59b30ee4617a7e1cc6ae89df348973" => :sierra
    sha256 "61011f8373be4e2810679c3c608e39f73fc7b47033ada9ae0b6f33513f185827" => :el_capitan
    sha256 "b9dc431b4db6bd91e1a839e4650eafdb9dcf71f238b6d7fda606aa1c36303f10" => :yosemite
  end

  depends_on "libusb" => :optional
  depends_on "qt@5.7"

  def install
    ENV.cxx11
    args = ["--disable-debug", "--disable-dependency-tracking",
            "--prefix=#{prefix}"]
    args << "--without-libusb" if build.without? "libusb"
    system "./configure", *args
    system "make", "install"
  end

  test do
    (testpath/"test.loc").write <<-EOS.undent
      <?xml version="1.0"?>
      <loc version="1.0">
        <waypoint>
          <name id="1 Infinite Loop"><![CDATA[Apple headquarters]]></name>
          <coord lat="37.331695" lon="-122.030091"/>
        </waypoint>
      </loc>
    EOS
    system bin/"gpsbabel", "-i", "geo", "-f", "test.loc", "-o", "gpx", "-F", "test.gpx"
    assert File.exist? "test.gpx"
  end
end
