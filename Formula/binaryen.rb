class Binaryen < Formula
  desc "Compiler infrastructure and toolchain library for WebAssembly"
  homepage "http://webassembly.org/"
  url "https://github.com/WebAssembly/binaryen/archive/version_34.tar.gz"
  sha256 "37ca02c53094d6bcd5d84a1fdd23fb5216015f92163c0471d20b7f16da9e54a0"

  head "https://github.com/WebAssembly/binaryen.git"

  bottle do
    cellar :any
    sha256 "54a170db5805e70d6fd62c2e60e2eaaa3d5d554bf8c20cf95b41ac1dc36ce782" => :sierra
    sha256 "34f38e8f125ec50c39864069b45e49f3c3bfa5e7ca02a91de0e995aba2aefb01" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on :macos => :el_capitan # needs thread-local storage

  needs :cxx11

  def install
    ENV.cxx11

    system "cmake", ".", *std_cmake_args
    system "make", "install"

    pkgshare.install "test/"
  end

  test do
    system "#{bin}/wasm-opt", "#{pkgshare}/test/passes/O.wast"
    system "#{bin}/asm2wasm", "#{pkgshare}/test/hello_world.asm.js"
  end
end
