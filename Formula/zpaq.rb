class Zpaq < Formula
  desc "Incremental, journaling command-line archiver"
  homepage "http://mattmahoney.net/dc/zpaq.html"
  url "http://mattmahoney.net/dc/zpaq714.zip"
  version "7.14"
  sha256 "7ebd2ecf6b7699cb1c9e02d3045698a71f684f83f48ebc18bad1a7e075b1b5f6"
  head "https://github.com/zpaq/zpaq.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3cea014c39c41c7208a17b80b9d7676a5e44757053916ea13a0cf65ea8166dc7" => :el_capitan
    sha256 "58823b3daa759acc9ccb2193382ccaf5c312201d9a20592c12bde9843b4b5341" => :yosemite
    sha256 "8a89183c78862909d2db2a68ece4b4a12e89167c460735d99f8afdd6b90af9ab" => :mavericks
  end

  resource "test" do
    url "http://mattmahoney.net/dc/calgarytest2.zpaq"
    sha256 "b110688939477bbe62263faff1ce488872c68c0352aa8e55779346f1bd1ed07e"
  end

  def install
    # Reported 6 Aug 2016 to mattmahoneyfl (at) gmail (dot) com
    # OS X `install` command doesn't have `-t`
    inreplace "Makefile", /(install -m.* )-t (.*) (.*)(\r)/, "\\1 \\3 \\2\\4"
    system "make"
    system "make", "check"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    testpath.install resource("test")
    assert_match "all OK", shell_output("#{bin}/zpaq x calgarytest2.zpaq 2>&1")
  end
end
