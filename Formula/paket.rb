class Paket < Formula
  desc "Dependency manager for .NET with support for NuGet and Git repositories"
  homepage "https://fsprojects.github.io/Paket/"
  url "https://github.com/fsprojects/Paket/releases/download/5.103.0/paket.exe"
  sha256 "aef9b05c832f43ff6fdd7f888ca03b7e9f704c0db94946d55f13941f613b01ee"

  bottle :unneeded

  depends_on "mono" => :recommended

  def install
    libexec.install "paket.exe"
    (bin/"paket").write <<-EOS.undent
      #!/bin/bash
      mono #{libexec}/paket.exe "$@"
    EOS
  end

  test do
    test_package_id = "Paket.Test"
    test_package_version = "1.2.3"

    touch testpath/"paket.dependencies"
    touch testpath/"testfile.txt"

    system bin/"paket", "install"
    assert (testpath/"paket.lock").exist?

    (testpath/"paket.template").write <<-EOS.undent
      type file

      id #{test_package_id}
      version #{test_package_version}
      authors Test package author

      description
          Description of this test package

      files
          testfile.txt ==> lib
    EOS

    system bin/"paket", "pack", "output", testpath
    assert (testpath/"#{test_package_id}.#{test_package_version}.nupkg").exist?
  end
end
