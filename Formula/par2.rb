class Par2 < Formula
  desc "Parchive: Parity Archive Volume Set for data recovery"
  homepage "https://github.com/Parchive/par2cmdline"
  url "https://github.com/Parchive/par2cmdline/releases/download/v0.7.1/par2cmdline-0.7.1.tar.bz2"
  sha256 "65bd96b96aece0c280025c2d4345a68e4d63f25fd408b4f617c033a2ff6196cd"

  bottle do
    cellar :any_skip_relocation
    sha256 "4f2d07227766ffce968051c244487b013fb45b6087e5fc8e0ca87a2783b8aa1e" => :sierra
    sha256 "d1f338d977a9b5f7f9c4cae67d39c0fcb3f42c822ef498676342afd22c07ae7a" => :el_capitan
    sha256 "bcf16976c9cee1d00ac73b19b59ae972508f8e354c94c8b9f40f3c403357044c" => :yosemite
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    # Protect a file with par2.
    test_file = testpath/"some-file"
    File.write(test_file, "file contents")
    system "#{bin}/par2", "create", test_file

    # "Corrupt" the file by overwriting, then ask par2 to repair it.
    File.write(test_file, "corrupted contents")
    repair_command_output = shell_output("#{bin}/par2 repair #{test_file}")

    # Verify that par2 claimed to repair the file.
    assert_match "1 file(s) exist but are damaged.", repair_command_output
    assert_match "Repair complete.", repair_command_output

    # Verify that par2 actually repaired the file.
    assert File.read(test_file) == "file contents"
  end
end
