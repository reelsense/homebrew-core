class FluentBit < Formula
  desc "Data Collector for IoT"
  homepage "https://github.com/fluent/fluent-bit"
  url "https://github.com/fluent/fluent-bit/archive/v0.7.2.tar.gz"
  sha256 "d89aa7eec925431fc1e77bae2895089c18f40070e3b390a5f375da57681d7bb3"

  head "https://github.com/fluent/fluent-bit.git"

  bottle do
    cellar :any
    sha256 "b907b620ecb4af4a954f89980a89a3fd683d9f0649c880e9523c07688f885cbd" => :el_capitan
    sha256 "74fa063fe85dbeb6b883cd56c899b731db677eac2c18eb4283421c0b315446e3" => :yosemite
    sha256 "ebecaf09f824d8441955963faa0cc7de491629bcd00ef2845647522ab99ae3f6" => :mavericks
  end

  depends_on "cmake" => :build

  conflicts_with "mbedtls", :because => "fluent-bit includes mbedtls libraries."

  def install
    system "cmake", ".", "-DWITH_IN_MEM=OFF", *std_cmake_args
    system "make", "install"
  end

  test do
    io = IO.popen("#{bin}/fluent-bit --input stdin --output stdout --daemon")
    sleep 1
    Process.kill("SIGINT", io.pid)
    Process.wait(io.pid)
    assert_match(/Fluent-Bit v#{version}/, io.read)
  end
end
