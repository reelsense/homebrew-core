class Osm2pgsql < Formula
  desc "OpenStreetMap data to PostgreSQL converter"
  homepage "https://wiki.openstreetmap.org/wiki/Osm2pgsql"
  url "https://github.com/openstreetmap/osm2pgsql/archive/0.92.1.tar.gz"
  sha256 "0912a344aaa38ed4b78f6dcab1a873975adb434dcc31cdd6fec3ec6a30025390"
  head "https://github.com/openstreetmap/osm2pgsql.git"

  bottle do
    sha256 "83079b4af4dc2b2e37b9b42ae39d7d29a272e2571c5e9afdbcaf94c6f7fa9c0f" => :sierra
    sha256 "a52cb4295d28d3ecfa71a7dfc23593588611c11fbb94035d791207da09da787d" => :el_capitan
    sha256 "cb4248c8b8ce11c4bd836387a3d48f0e8bd297d609b5f70a8c4581a82d13aba1" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on :postgresql
  depends_on "boost"
  depends_on "geos"
  depends_on "proj"
  depends_on "lua" => :recommended

  # Compatibility with GEOS 3.6.1
  # Upstream PR from 27 Oct 2016 "Geos36"
  patch do
    url "https://github.com/openstreetmap/osm2pgsql/pull/636.patch?full_index=1"
    sha256 "4e060b20972b049e853b4582f8b3d41a2b98eeece7a5ee00ababdf14eb44154a"
  end

  def install
    args = std_cmake_args

    if build.with? "lua"
      # This is essentially a CMake disrespects superenv problem
      # rather than an upstream issue to handle.
      lua_version = Formula["lua"].version.to_s.match(/\d\.\d/)
      inreplace "cmake/FindLua.cmake", "LUA_VERSIONS5 5.3 5.2 5.1 5.0",
                                       "LUA_VERSIONS5 #{lua_version}"
    else
      args << "-DWITH_LUA=OFF"
    end

    mkdir "build" do
      system "cmake", "..", *args
      system "make", "install"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/osm2pgsql -h 2>&1")
  end
end
