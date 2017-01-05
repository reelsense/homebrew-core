class Rocksdb < Formula
  desc "Embeddable, persistent key-value store for fast storage"
  homepage "http://rocksdb.org"
  url "https://github.com/facebook/rocksdb/archive/v4.13.5.tar.gz"
  sha256 "3384655107f59a6ee9a52a54d0631d9ae96c722e411bafe6c4547ec4fc201534"
  revision 1

  bottle do
    cellar :any
    sha256 "f6068e94fbcd3c9e8be1c9e9cdd0eebcf4c0d7f75404d3d6365f9b8d0a02782a" => :sierra
    sha256 "4eafd1dfc2a03304240975f0925e8595f0e66bb5024d5304d493f7e114fc4935" => :el_capitan
    sha256 "f4f7cf93232346541233495f82e960975b4523e3dac52fdc484ad89c840947d2" => :yosemite
  end

  option "without-lite", "Don't build mobile/non-flash optimized lite version"
  option "with-tools", "Build tools"

  needs :cxx11
  depends_on "snappy"
  depends_on "lz4"
  depends_on "gflags"

  def install
    ENV.cxx11
    ENV["PORTABLE"] = "1" if build.bottle?
    if build.with? "lite"
      ENV.append_to_cflags "-DROCKSDB_LITE=1"
      ENV["LIBNAME"] = "librocksdb_lite"
    end
    system "make", "clean"
    system "make", "static_lib"
    system "make", "shared_lib"
    system "make", "tools" if build.with? "tools"
    system "make", "install", "INSTALL_PATH=#{prefix}"
    if build.with? "tools"
      bin.install "sst_dump" => "rocksdb_sst_dump"
      bin.install "db_sanity_test" => "rocksdb_sanity_test"
      bin.install "db_stress" => "rocksdb_stress"
      bin.install "write_stress" => "rocksdb_write_stress"
      bin.install "ldb" => "rocksdb_ldb"
      bin.install "db_repl_stress" => "rocksdb_repl_stress"
      bin.install "rocksdb_dump"
      bin.install "rocksdb_undump"
    end
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <assert.h>
      #include <rocksdb/options.h>
      #include <rocksdb/memtablerep.h>
      using namespace rocksdb;
      int main() {
        Options options;
        return 0;
      }
    EOS

    system ENV.cxx, "test.cpp", "-o", "db_test", "-v",
                                "-std=c++11", "-stdlib=libc++", "-lstdc++",
                                "-lz", "-lbz2",
                                "-L#{lib}", "-lrocksdb_lite",
                                "-L#{Formula["snappy"].opt_lib}", "-lsnappy",
                                "-L#{Formula["lz4"].opt_lib}", "-llz4"
    system "./db_test"

    if build.with? "tools"
      system "#{bin}/rocksdb_sst_dump", "--help"
      system "#{bin}/rocksdb_sanity_test", "--help"
      system "#{bin}/rocksdb_stress", "--help"
      system "#{bin}/rocksdb_write_stress", "--help"
      system "#{bin}/rocksdb_ldb", "--help"
      system "#{bin}/rocksdb_repl_stress", "--help"
      system "#{bin}/rocksdb_dump", "--help"
      system "#{bin}/rocksdb_undump", "--help"
    end
  end
end
