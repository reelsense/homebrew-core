class Serd < Formula
  desc "C library for RDF syntax"
  homepage "https://drobilla.net/software/serd/"
  url "https://download.drobilla.net/serd-0.26.0.tar.bz2"
  sha256 "e3e44a88f90a9971d55e6cbd59a7b9cfa97cfc17c512fed7166a4252d5209298"

  bottle do
    cellar :any
    sha256 "8ad52906db138cc480a3d75c1f9b6f245456a80c47de220c83acf7778bb55c48" => :sierra
    sha256 "dfd1ede14146b8222cf65e39c7dafe368a4abd474b2c5babddcd883a9f112743" => :el_capitan
    sha256 "654ac6e9843657faad3ec005d476f8812f9630e4ad56878c24bf93c17f66fa64" => :yosemite
  end

  depends_on "pkg-config" => :build

  def install
    system "./waf", "configure", "--prefix=#{prefix}"
    system "./waf"
    system "./waf", "install"
  end
end
