class Ranger < Formula
  desc "File browser"
  homepage "http://ranger.nongnu.org/"
  url "http://ranger.nongnu.org/ranger-1.8.0.tar.gz"
  sha256 "ce02476cb93d51b901eb6f5f0fc9675c58bd0a2f11d2ce0cdb667e15ec314092"

  head "git://git.savannah.nongnu.org/ranger.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "134b13f0873516b6e3b04c757a19cddd0f2daf5291b6094b608d7a72e146af64" => :sierra
    sha256 "b03b18490965e67475c1bbe1c1423427772bff7760fb6213ae60aec55af9008f" => :el_capitan
    sha256 "b03b18490965e67475c1bbe1c1423427772bff7760fb6213ae60aec55af9008f" => :yosemite
  end

  # requires 2.6 or newer; Leopard comes with 2.5
  depends_on :python if MacOS.version <= :leopard

  def install
    if MacOS.version <= :leopard
      inreplace %w[ranger.py ranger/ext/rifle.py],
        "#!/usr/bin/python", "#!#{PythonRequirement.new.which_python}"
    end

    man1.install "doc/ranger.1"
    libexec.install "ranger.py", "ranger"
    bin.install_symlink libexec+"ranger.py" => "ranger"
    doc.install "examples"
  end

  test do
    assert_match version.to_s, shell_output("script -q /dev/null #{bin}/ranger --version")
  end
end
