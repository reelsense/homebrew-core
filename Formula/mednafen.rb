class Mednafen < Formula
  desc "Multi-system emulator"
  homepage "http://mednafen.fobby.net/"
  url "https://mednafen.github.io/releases/files/mednafen-0.9.43.tar.xz"
  sha256 "b8305914cdf297fe6483219fa10c3fa14116fff8eed02f61326a0e32dd350f4d"

  bottle do
    sha256 "9908e6cb239537aa01483895f427faf064e22fd15621cbdbfe8a370893f28205" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "sdl"
  depends_on "libsndfile"
  depends_on :macos => :sierra # needs clock_gettime
  depends_on "gettext"

  def install
    # Fix run-time crash "Assertion failed: (x == TestLLVM15470_Counter), function
    # TestLLVM15470_Sub2, file tests.cpp, line 643."
    # LLVM miscompiles some loop code with optimization
    # https://llvm.org/bugs/show_bug.cgi?id=15470
    ENV.O2

    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make", "install"
  end

  test do
    cmd = "#{bin}/mednafen -dump_modules_def M >/dev/null || head -n 1 M"
    assert_equal version.to_s, shell_output(cmd).chomp
  end
end
