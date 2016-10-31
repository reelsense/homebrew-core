class Loc < Formula
  desc "Count lines of code quickly"
  homepage "https://github.com/cgag/loc"
  url "https://github.com/cgag/loc/archive/v0.3.2.tar.gz"
  sha256 "0b805d53326f269e8fe21f709dc69947820fda1f291040e9225f93aef614daea"

  bottle do
    cellar :any_skip_relocation
    sha256 "f8e02aa9be7cc54fd208ad8873d5dacd05b55ea2af09404687147031cb0de4e3" => :sierra
    sha256 "a1d436d26fb2f10f388f07185a2caa0f5cca0687f2283a5fe51f85950ad80b69" => :el_capitan
    sha256 "cc5374a4923336da1448f7c3c9f64ddec7fbb65bcc433f133c8ca68b09cc340d" => :yosemite
  end

  depends_on "rust" => :build

  def install
    system "cargo", "build", "--release"
    bin.install "target/release/loc"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <stdio.h>
      int main() {
        println("Hello World");
        return 0;
      }
    EOS
    system bin/"loc", "test.cpp"
  end
end
