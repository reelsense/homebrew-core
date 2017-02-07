class AflFuzz < Formula
  desc "American fuzzy lop: Security-oriented fuzzer"
  homepage "http://lcamtuf.coredump.cx/afl/"
  url "http://lcamtuf.coredump.cx/afl/releases/afl-2.37b.tgz"
  sha256 "9cf072c9a1a92e5ed8d3cc69addd2ca7c5e562db88505e09dc060167038c299b"

  bottle do
    sha256 "7d066e0c0d396a5913f68f07f5009232533a6a10c9543e0f793027f43685d91d" => :sierra
    sha256 "91ee6f5388c813bcc85355358bda4042a671f788a507358d930dd1f032889f7f" => :el_capitan
    sha256 "ec2e11fe28d117e298539e6881250e588d62703cc11bba7728c33d632b49cfd1" => :yosemite
  end

  def install
    system "make", "PREFIX=#{prefix}"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    cpp_file = testpath/"main.cpp"
    cpp_file.write <<-EOS.undent
      #include <iostream>

      int main() {
        std::cout << "Hello, world!";
      }
    EOS

    system bin/"afl-clang++", "-g", cpp_file, "-o", "test"
    assert_equal "Hello, world!", shell_output("./test")
  end
end
