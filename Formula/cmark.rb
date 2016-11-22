class Cmark < Formula
  desc "Strongly specified, highly compatible implementation of Markdown"
  homepage "http://commonmark.org"
  url "https://github.com/jgm/cmark/archive/0.27.1.tar.gz"
  sha256 "669b4c19355e8cb90139fdd03b02283b97130e92ea99a104552a2976751446b5"

  bottle do
    cellar :any
    sha256 "a6e19a07d842962cf8b5a4ac891d1145e3bff3b28307badca63ad581fbcfc0dd" => :sierra
    sha256 "daccc233aa1367aadeefe40922375dfdf6a05c0a3f5ef5d667e8468137b9b9a3" => :el_capitan
    sha256 "0ce1dc7e2b53e07d798a6106cb4aabe5ee762832367413bacfba581cd2157aea" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on :python3 => :build

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make"
      system "make", "test"
      system "make", "install"
    end
  end

  test do
    output = pipe_output("#{bin}/cmark", "*hello, world*")
    assert_equal "<p><em>hello, world</em></p>", output.chomp
  end
end
