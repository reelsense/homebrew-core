class ProtobufSwift < Formula
  desc "Implementation of Protocol Buffers in Swift"
  homepage "https://github.com/alexeyxo/protobuf-swift"
  url "https://github.com/alexeyxo/protobuf-swift/archive/3.0.22.tar.gz"
  sha256 "3d24391b0e91c0bf665aa045b99279300b6ebaaf0aff18a273b5f39aabcd3700"
  revision 1

  bottle do
    cellar :any
    sha256 "9e75251dd05ba86f0cbb7b56e3941d56619f2db1e95d9d58c4e466dfbb745fc8" => :sierra
    sha256 "2291fc0bf3539f69c1f92b259b03be5c343a6793e2496d05753f080f2d6d8b82" => :el_capitan
    sha256 "abbb99094a069075df11331640e3c47ba668040445defbe01073026d6966f99e" => :yosemite
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  # Upstream issue "protobuf 3.4.0 build failure"
  # Reported 16 Aug 2017 https://github.com/alexeyxo/protobuf-swift/issues/217
  depends_on "protobuf@3.1"

  def install
    system "protoc", "-Iplugin/compiler",
                     "plugin/compiler/google/protobuf/descriptor.proto",
                     "plugin/compiler/google/protobuf/swift-descriptor.proto",
                     "--cpp_out=plugin/compiler"
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
    system Formula["protobuf@3.1"].opt_bin/"protoc", "test.proto", "--swift_out=."
  end
end
