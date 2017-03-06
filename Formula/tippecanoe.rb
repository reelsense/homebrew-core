class Tippecanoe < Formula
  desc "Build vector tilesets from collections of GeoJSON features"
  homepage "https://github.com/mapbox/tippecanoe"
  url "https://github.com/mapbox/tippecanoe/archive/1.16.11.tar.gz"
  sha256 "7a3b9764efad52c2e63df67c3d85c708aed0190a694bb9cd3f0171010763d519"

  bottle do
    cellar :any_skip_relocation
    sha256 "161bb06dc2a985d558e4e0fe5b49b2b2c720081d07fb14faa55d24a991d1f18e" => :sierra
    sha256 "7c6ca27a0a57a51a2b7c01cd8b690112bc44a10a1bedf1f9800c999e9234c451" => :el_capitan
    sha256 "3a73ead09aebdf27c92a75d3a4bcac84fee92ec916b91d2796bf94e3f18ddb34" => :yosemite
  end

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"test.json").write <<-EOS.undent
      {"type":"Feature","properties":{},"geometry":{"type":"Point","coordinates":[0,0]}}
    EOS
    safe_system "#{bin}/tippecanoe", "-o", "test.mbtiles", "test.json"
    assert File.exist?("#{testpath}/test.mbtiles"), "tippecanoe generated no output!"
  end
end
