require "language/haskell"

class PandocCiteproc < Formula
  include Language::Haskell::Cabal

  desc "Library and executable for using citeproc with pandoc"
  homepage "https://github.com/jgm/pandoc-citeproc"
  url "https://hackage.haskell.org/package/pandoc-citeproc-0.10.3/pandoc-citeproc-0.10.3.tar.gz"
  sha256 "2f6233ff91a9fb08edfb0ac2b4ec40729d87590a7c557d0452674dd3c7df4d58"
  head "https://github.com/jgm/pandoc-citeproc.git"

  bottle do
    sha256 "e6c7ab6dcf59aea1367eac17e1a649917fd8cafa07f17ad81ee419b3da595b43" => :sierra
    sha256 "33454243989046fa696800af3814353d80e076d55f013d2c6fa43ad627499887" => :el_capitan
    sha256 "7b4e38c77212bbec46a30e95ee544b5d218222f6698fc90e02635a1bddb99705" => :yosemite
  end

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build
  depends_on "pandoc"

  def install
    # Build error with aeson >= 1.0.0.0: "Overlapping instances for FromJSON"
    # Reported 27 Oct 2016 https://github.com/jgm/pandoc-citeproc/issues/263
    inreplace "pandoc-citeproc.cabal",
      "aeson >= 0.7 && < 1.1, text, vector,",
      "aeson >= 0.7 && < 1.0.0.0, text, vector,"

    args = []
    args << "--constraint=cryptonite -support_aesni" if MacOS.version <= :lion
    install_cabal_package *args
  end

  test do
    (testpath/"test.bib").write <<-EOS.undent
      @Book{item1,
      author="John Doe",
      title="First Book",
      year="2005",
      address="Cambridge",
      publisher="Cambridge University Press"
      }
    EOS
    expected = <<-EOS.undent
      ---
      references:
      - id: item1
        type: book
        author:
        - family: Doe
          given: John
        issued:
        - year: '2005'
        title: First book
        publisher: Cambridge University Press
        publisher-place: Cambridge
      ...
    EOS
    assert_equal expected, shell_output("#{bin}/pandoc-citeproc -y test.bib")
  end
end
