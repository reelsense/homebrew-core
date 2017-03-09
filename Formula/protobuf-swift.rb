class ProtobufSwift < Formula
  desc "Implementation of Protocol Buffers in Apple Swift."
  homepage "https://github.com/alexeyxo/protobuf-swift"
  url "https://github.com/alexeyxo/protobuf-swift/archive/3.0.13.tar.gz"
  sha256 "79bd0604bf8a41120334db94c84c49f9f03c0796a0f985774bf361a659e474d1"

  bottle do
    cellar :any
    sha256 "1a6536a233f9e182b77dae6c21b932316b768fee8871ec88bb9c19cc2be66b08" => :sierra
    sha256 "982020ec27137097761b43f579c8a66419bafdb09da46df9e748240f10ae5c24" => :el_capitan
    sha256 "7b170c153dd079b73214e498dd84a179e4ebe8c24e134ba5821daf71571a3e23" => :yosemite
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "protobuf"

  def install
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    testdata = <<-EOS.undent
      syntax = "proto3";
      enum Flavor {
        CHOCOLATE = 0;
        VANILLA = 1;
      }
      message IceCreamCone {
        int32 scoops = 1;
        Flavor flavor = 2;
      }
    EOS
    (testpath/"test.proto").write(testdata)
    system "protoc", "test.proto", "--swift_out=."
  end
end
