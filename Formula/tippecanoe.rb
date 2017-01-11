class Tippecanoe < Formula
  desc "Build vector tilesets from collections of GeoJSON features"
  homepage "https://github.com/mapbox/tippecanoe"
  url "https://github.com/mapbox/tippecanoe/archive/1.16.3.tar.gz"
  sha256 "ccc11f27bf3f50dbe0a41496474398e9a72c8fd792e7177550eb04b1740e09eb"

  bottle do
    cellar :any_skip_relocation
    sha256 "dd946940a9052a5bb258cf5887341a8e67e7b5d72291dc6bffce637609f7a2cd" => :sierra
    sha256 "588057d5589905ae0d86d83a20b0873c5b558d130c95cab90cd8b3a50c0b3efd" => :el_capitan
    sha256 "5c5a5bafdb8def525cc358ef8a3daf900e307c785f93ed554a11a5457dfd6254" => :yosemite
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
