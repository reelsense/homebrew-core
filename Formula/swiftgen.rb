class Swiftgen < Formula
  desc "Collection of Swift tools to generate Swift code"
  homepage "https://github.com/AliSoftware/SwiftGen"
  url "https://github.com/AliSoftware/SwiftGen/archive/2.0.0.tar.gz"
  sha256 "dcf2a1d0fbcc57e96771be62474bbb4af6f5090e061b8ea3b63f4c5e682e529e"
  head "https://github.com/AliSoftware/SwiftGen.git"

  bottle do
    cellar :any
    sha256 "c64e714e3dc1367d72fd22e9867a1782fa1cff60944150e99efc0c7f6dea0636" => :el_capitan
    sha256 "b1abc22ac4d4e306a80df7aba47f70225faa8a4e81ac1d69e09754f194bb2f83" => :yosemite
  end

  depends_on :xcode => "7.0"

  def install
    rake "install[#{bin},#{lib},#{pkgshare}/templates]"

    fixtures = %w[
      UnitTests/fixtures/Images.xcassets
      UnitTests/fixtures/colors.txt
      UnitTests/fixtures/Localizable.strings
      UnitTests/fixtures/Storyboards-iOS/Message.storyboard
      UnitTests/fixtures/Fonts
      UnitTests/expected/Images-File-Default.swift.out
      UnitTests/expected/Colors-Txt-File-Default.swift.out
      UnitTests/expected/Strings-File-Default.swift.out
      UnitTests/expected/Storyboards-Message-Default.swift.out
      UnitTests/expected/Fonts-Dir-Default.swift.out
    ]
    (pkgshare/"fixtures").install fixtures
  end

  test do
    system bin/"swiftgen", "--version"

    fixtures = pkgshare/"fixtures"

    output = shell_output("#{bin}/swiftgen images --templatePath #{pkgshare/"templates/images-default.stencil"} #{fixtures}/Images.xcassets").strip
    assert_equal output, (fixtures/"Images-File-Default.swift.out").read.strip, "swiftgen images failed"

    output = shell_output("#{bin}/swiftgen colors --templatePath #{pkgshare/"templates/colors-default.stencil"} #{fixtures}/colors.txt").strip
    assert_equal output, (fixtures/"Colors-Txt-File-Default.swift.out").read.strip, "swiftgen colors failed"

    output = shell_output("#{bin}/swiftgen strings --templatePath #{pkgshare/"templates/strings-default.stencil"} #{fixtures}/Localizable.strings").strip
    assert_equal output, (fixtures/"Strings-File-Default.swift.out").read.strip, "swiftgen strings failed"

    output = shell_output("#{bin}/swiftgen storyboards --templatePath #{pkgshare/"templates/storyboards-default.stencil"} #{fixtures}/Message.storyboard").strip
    assert_equal output, (fixtures/"Storyboards-Message-Default.swift.out").read.strip, "swiftgen storyboards failed"

    output = shell_output("#{bin}/swiftgen fonts --templatePath #{pkgshare/"templates/fonts-default.stencil"} #{fixtures}/Fonts").strip
    assert_equal output, (fixtures/"Fonts-Dir-Default.swift.out").read.strip, "swiftgen fonts failed"
  end
end
