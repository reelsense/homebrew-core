class SqliteAnalyzer < Formula
  desc "Analyze how space is allocated inside an SQLite file"
  homepage "https://www.sqlite.org/"
  url "https://www.sqlite.org/2017/sqlite-src-3160200.zip"
  version "3.16.2"
  sha256 "ee77c2cc5cc4a7b0a746a1d4496f7aee0d71c558a3bbfcf8e9e0b35416910337"

  bottle do
    cellar :any_skip_relocation
    sha256 "d898e91b3d86d8f60859b2ff4390c8602420c35244d27d2e0dc7e2a085f984fa" => :sierra
    sha256 "882ef78062b7bc7941067588496ebff2b7035f712b4e3e141224f6b257779369" => :el_capitan
    sha256 "bd0352e7d631d391cf08ecbf8164ee0bb12c8c01c8d62a472739fbe3867d1a84" => :yosemite
  end

  def install
    system "./configure", "--disable-debug", "--prefix=#{prefix}"
    system "make", "sqlite3_analyzer"
    bin.install "sqlite3_analyzer"
  end

  test do
    dbpath = testpath/"school.sqlite"
    sqlpath = testpath/"school.sql"
    sqlpath.write <<-EOS.undent
      create table students (name text, age integer);
      insert into students (name, age) values ('Bob', 14);
      insert into students (name, age) values ('Sue', 12);
      insert into students (name, age) values ('Tim', 13);
    EOS
    system "/usr/bin/sqlite3 #{dbpath} < #{sqlpath}"
    system bin/"sqlite3_analyzer", dbpath
  end
end
