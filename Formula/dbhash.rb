class Dbhash < Formula
  desc "Computes the SHA1 hash of schema and content of a SQLite database"
  homepage "https://www.sqlite.org/dbhash.html"
  url "https://www.sqlite.org/2017/sqlite-src-3160200.zip"
  version "3.16.2"
  sha256 "ee77c2cc5cc4a7b0a746a1d4496f7aee0d71c558a3bbfcf8e9e0b35416910337"

  bottle do
    cellar :any_skip_relocation
    sha256 "8d65e3906e7a38035f9cda419bba2af5bd7447b70420f83c5d2190478d24c391" => :sierra
    sha256 "39eef693805627a753a000ff44043f61541a62ed0c3c7fb96ba30243aca5b67f" => :el_capitan
    sha256 "d55f82a1f4b8d3cd2ae2ff110de22f274f94b521ae6bd0b60cde4116a575b756" => :yosemite
  end

  def install
    system "./configure", "--disable-debug", "--prefix=#{prefix}"
    system "make", "dbhash"
    bin.install "dbhash"
  end

  test do
    dbpath = testpath/"test.sqlite"
    sqlpath = testpath/"test.sql"
    sqlpath.write "create table test (name text);"
    system "/usr/bin/sqlite3 #{dbpath} < #{sqlpath}"
    assert_equal "b6113e0ce62c5f5ca5c9f229393345ce812b7309",
                 shell_output("#{bin}/dbhash #{dbpath}").strip.split.first
  end
end
