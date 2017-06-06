class OpenalSoft < Formula
  desc "Implementation of the OpenAL 3D audio API"
  homepage "http://kcat.strangesoft.net/openal.html"
  url "http://kcat.strangesoft.net/openal-releases/openal-soft-1.18.0.tar.bz2"
  sha256 "4433b1391c61a7ca36d82c946c8f0ffe410569d6437e4ce72b3547aaf966ecde"
  head "http://repo.or.cz/openal-soft.git"

  bottle do
    cellar :any
    sha256 "b9738e2a954a3556e8b757793960a8319a9d7ace8542e0f4dea34f8a74b4600f" => :sierra
    sha256 "8738d5184ab0af02e2f63b363572365f9174876fadd93196f6bca0a0625b2b08" => :el_capitan
    sha256 "5eaff28134246e2286996d2bd0f9f25951a157aa2332486df3adf9e092ccb39c" => :yosemite
  end

  keg_only :provided_by_osx, "macOS provides OpenAL.framework"

  depends_on "pkg-config" => :build
  depends_on "cmake" => :build
  depends_on "portaudio" => :optional
  depends_on "pulseaudio" => :optional
  depends_on "fluid-synth" => :optional

  # clang 4.2's support for alignas is incomplete
  fails_with(:clang) { build 425 }

  def install
    # Please don't reenable example building. See:
    # https://github.com/Homebrew/homebrew/issues/38274
    args = std_cmake_args
    args << "-DALSOFT_EXAMPLES=OFF"

    args << "-DALSOFT_BACKEND_PORTAUDIO=OFF" if build.without? "portaudio"
    args << "-DALSOFT_BACKEND_PULSEAUDIO=OFF" if build.without? "pulseaudio"
    args << "-DALSOFT_MIDI_FLUIDSYNTH=OFF" if build.without? "fluid-synth"

    system "cmake", ".", *args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include "AL/al.h"
      #include "AL/alc.h"
      int main() {
        ALCdevice *device;
        device = alcOpenDevice(0);
        alcCloseDevice(device);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lopenal"
  end
end
