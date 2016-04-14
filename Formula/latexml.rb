class Latexml < Formula
  desc "LaTeX to XML/HTML/MathML Converter"
  homepage "http://dlmf.nist.gov/LaTeXML"
  url "https://github.com/brucemiller/LaTeXML/archive/v0.8.1.tar.gz"
  sha256 "2ba1a580258ff5c7e3d9c2b40fd15cb4c92e388e5cd6b6127e8fbf9b1b9c63ce"

  bottle do
    cellar :any_skip_relocation
    sha256 "ebef5edcdc7b8b992e547fcc57a0af84c9154391d21e9b63b1d8a4bfd90dcb18" => :el_capitan
    sha256 "7b10c703cc3a89062210570d74ec27976d33a185b1a089e44ff438e7962d7d8d" => :yosemite
    sha256 "916998851d7466e0b86d389b8385a9d4113f1da8105102c42e3f7fece8f31533" => :mavericks
  end

  resource "Image::Size" do
    url "https://cpan.metacpan.org/authors/id/R/RJ/RJRAY/Image-Size-3.300.tar.gz"
    mirror "http://search.cpan.org/CPAN/authors/id/R/RJ/RJRAY/Image-Size-3.300.tar.gz"
    sha256 "53c9b1f86531cde060ee63709d1fda73cabc0cf2d581d29b22b014781b9f026b"
  end

  def install
    ENV.prepend_create_path "PERL5LIB", libexec+"lib/perl5"
    resources.each do |r|
      r.stage do
        system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
        system "make"
        system "make", "install"
      end
    end

    system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
    system "make", "install"
    doc.install "manual.pdf"
    (libexec+"bin").find.each do |path|
      next if path.directory?
      program = path.basename
      (bin+program).write_env_script("#{libexec}/bin/#{program}", :PERL5LIB => ENV["PERL5LIB"])
    end
  end

  test do
    (testpath/"test.tex").write <<-EOS.undent
    \\documentclass{article}
    \\title{LaTeXML Homebrew Test}
    \\begin{document}
    \\maketitle
    \\end{document}
    EOS
    assert_match %r{<title>LaTeXML Homebrew Test</title>},
      shell_output("#{bin}/latexml --quiet #{testpath}/test.tex 2>/dev/null")
  end
end
