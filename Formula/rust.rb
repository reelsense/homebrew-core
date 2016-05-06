class Rust < Formula
  desc "Safe, concurrent, practical language"
  homepage "https://www.rust-lang.org/"

  stable do
    url "https://static.rust-lang.org/dist/rustc-1.8.0-src.tar.gz"
    sha256 "af4466147e8d4db4de2a46e07494d2dc2d96313c5b37da34237f511c905f7449"

    resource "cargo" do
      # git required because of submodules
      url "https://github.com/rust-lang/cargo.git", :tag => "0.10.0", :revision => "10ddd7d5b3080fb0fa6c720cedca64407d4ca2f9"
    end

    # name includes date to satisfy cache
    resource "cargo-nightly-2015-09-17" do
      url "https://static-rust-lang-org.s3.amazonaws.com/cargo-dist/2015-09-17/cargo-nightly-x86_64-apple-darwin.tar.gz"
      sha256 "02ba744f8d29bad84c5e698c0f316f9e428962b974877f7f582cd198fdd807a8"
    end

    # Build on Xcode 7.3
    # https://github.com/rust-lang/rust/issues/32442
    patch do
      url "https://github.com/rust-lang/rust/commit/79da64a.diff"
      sha256 "78ebf373cb19be5fef053776729109824cc7bbbd2bd375e9c444bef7ea41faf7"
    end
  end

  head do
    url "https://github.com/rust-lang/rust.git"
    resource "cargo" do
      url "https://github.com/rust-lang/cargo.git"
    end
  end

  bottle do
    sha256 "03e67aa150b81d8b00c0e82ffc76e9b38e6d07eb8e0adef7795fafe25bea8a64" => :el_capitan
    sha256 "c1e88294e0056b25bc73a21396fb206914ce733bffe2a5e94bfeaca5e4998479" => :yosemite
    sha256 "645c4d3fbd6760936582a0cef017c0dfb9885f83b32b110382d39c757084ce9a" => :mavericks
  end

  option "with-llvm", "Build with brewed LLVM. By default, Rust's LLVM will be used."

  depends_on "cmake" => :build
  depends_on "pkg-config" => :run
  depends_on "llvm" => :optional
  depends_on "openssl"
  depends_on "libssh2"

  conflicts_with "multirust", :because => "both install rustc, rustdoc, cargo, rust-lldb, rust-gdb"

  # According to the official readme, GCC 4.7+ is required
  fails_with :gcc_4_0
  fails_with :gcc
  ("4.3".."4.6").each do |n|
    fails_with :gcc => n
  end

  def install
    # Because we copy the source tree to a temporary build directory,
    # the absolute paths written to the `gitdir` files of the
    # submodules are no longer accurate, and running `git submodule
    # update` during the configure step fails.
    ENV["CFG_DISABLE_MANAGE_SUBMODULES"] = "1" if build.head?

    args = ["--prefix=#{prefix}"]
    args << "--disable-rpath" if build.head?
    args << "--enable-clang" if ENV.compiler == :clang
    args << "--llvm-root=#{Formula["llvm"].opt_prefix}" if build.with? "llvm"
    if build.head?
      args << "--release-channel=nightly"
    else
      args << "--release-channel=stable"
    end
    system "./configure", *args
    system "make"
    system "make", "install"

    resource("cargo").stage do
      cargo_stage_path = pwd

      if build.stable?
        resource("cargo-nightly-2015-09-17").stage do
          system "./install.sh", "--prefix=#{cargo_stage_path}/target/snapshot/cargo"
          # satisfy make target to skip download
          touch "#{cargo_stage_path}/target/snapshot/cargo/bin/cargo"
        end
      end

      system "./configure", "--prefix=#{prefix}", "--local-rust-root=#{prefix}", "--enable-optimize"
      system "make"
      system "make", "install"
    end

    rm_rf prefix/"lib/rustlib/uninstall.sh"
    rm_rf prefix/"lib/rustlib/install.log"
  end

  test do
    system "#{bin}/rustdoc", "-h"
    (testpath/"hello.rs").write <<-EOS.undent
    fn main() {
      println!("Hello World!");
    }
    EOS
    system "#{bin}/rustc", "hello.rs"
    assert_equal "Hello World!\n", `./hello`
    system "#{bin}/cargo", "new", "hello_world", "--bin"
    assert_equal "Hello, world!",
                 (testpath/"hello_world").cd { `#{bin}/cargo run`.split("\n").last }
  end
end
