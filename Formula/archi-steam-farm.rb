class ArchiSteamFarm < Formula
  desc "ASF is a C# application that allows you to farm steam cards"
  homepage "https://github.com/JustArchi/ArchiSteamFarm"
  url "https://github.com/JustArchi/ArchiSteamFarm/releases/download/2.1.5.4/ASF.zip"
  sha256 "244f2e213927ad4512036a30bff201d94db1129a9f8650e39bdbf22a0f4951f8"

  bottle do
    cellar :any_skip_relocation
    sha256 "3688dab74bde7418f71352ed30ccef036336351b660daf306567173f71997d55" => :sierra
    sha256 "3688dab74bde7418f71352ed30ccef036336351b660daf306567173f71997d55" => :el_capitan
    sha256 "3688dab74bde7418f71352ed30ccef036336351b660daf306567173f71997d55" => :yosemite
  end

  depends_on "mono"

  def install
    libexec.install "ASF.exe"
    (bin/"asf").write <<-EOS.undent
      #!/bin/bash
      mono #{libexec}/ASF.exe "$@"
    EOS

    etc.install "config" => "asf"
    libexec.install_symlink etc/"asf" => "config"
  end

  test do
    assert_match "ASF V2.1.5.4", shell_output("#{bin}/asf --client")
  end
end
