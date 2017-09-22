class Swimat < Formula
  desc "Command-line tool to help format Swift code"
  homepage "https://github.com/Jintin/Swimat"
  url "https://github.com/Jintin/Swimat/archive/v1.4.0.tar.gz"
  sha256 "5ff76cdb2a51763dc7ca9a5a9c3f76f5a2d313da7a630dc55ef4680792a622b8"
  head "https://github.com/Jintin/Swimat.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1f4c07b9692324985d6159cb668a8f3f167dda1f432f2c80d6a38b0cebc256aa" => :high_sierra
    sha256 "a3aa934ff2c10453052307caacb776e672869524ceb70d05c9b6ff7853d1495b" => :sierra
    sha256 "f63affac1320d7321c350d649adb3f794bb9002c7c6191039e4055a280dff2fd" => :el_capitan
  end

  depends_on :xcode => "8.0"

  def install
    xcodebuild "-target", "CLI",
               "-configuration", "Release",
               "CODE_SIGN_IDENTITY=",
               "SYMROOT=build"
    bin.install "build/Release/swimat"
  end

  test do
    system "#{bin}/swimat", "-h"
    (testpath/"SwimatTest.swift").write("struct SwimatTest {}")
    system "#{bin}/swimat", "#{testpath}/SwimatTest.swift"
  end
end
