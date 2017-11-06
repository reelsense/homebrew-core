class Ocamlbuild < Formula
  desc "Generic build tool for OCaml"
  homepage "https://github.com/ocaml/ocamlbuild"
  url "https://github.com/ocaml/ocamlbuild/archive/0.11.0.tar.gz"
  sha256 "1717edc841c9b98072e410f1b0bc8b84444b4b35ed3b4949ce2bec17c60103ee"
  revision 3
  head "https://github.com/ocaml/ocamlbuild.git"

  bottle do
    sha256 "16c1d84895f766e95e5a4d5b52c6ef94a392d570a0ceeb1c0d884d06e17f88f9" => :high_sierra
    sha256 "31aa1670e71e813d2c84ba3d593e51ac99c66bcee2d00d0ed5f2d3fcd58fec3b" => :sierra
    sha256 "3634d6b1a4be0876183c94b30bd9a80a620051a7d67761dd1403703dbd51b80e" => :el_capitan
  end

  depends_on "ocaml"

  def install
    system "make", "configure", "OCAMLBUILD_BINDIR=#{bin}", "OCAMLBUILD_LIBDIR=#{lib}", "OCAMLBUILD_MANDIR=#{man}"
    system "make"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ocamlbuild --version")
  end
end
