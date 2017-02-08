class Fstar < Formula
  desc "Language with a type system for program verification"
  homepage "https://www.fstar-lang.org/"
  url "https://github.com/FStarLang/FStar.git",
      :tag => "v0.9.4.0",
      :revision => "2137ca0fbc56f04e202f715202c85a24b36c3b29"
  head "https://github.com/FStarLang/FStar.git"

  bottle do
    cellar :any
    sha256 "c0e12f89c58c63d456c194206243b1c2b9cbea1857afe7f2fd31fa3b709c2797" => :sierra
    sha256 "632b24047df19cc9568fe46c3e5041cfc0c0858f3139aaa7c3bc9905a55f87df" => :el_capitan
    sha256 "97c2b2db56554822f03293d74099db6f20386d512287295a5d16b8ed265a2899" => :yosemite
  end

  depends_on "opam" => :build
  depends_on "gmp"
  depends_on "ocaml" => :recommended
  depends_on "z3" => :recommended

  def install
    ENV.deparallelize # Not related to F* : OCaml parallelization
    ENV["OPAMROOT"] = buildpath/"opamroot"
    ENV["OPAMYES"] = "1"

    # avoid having to depend on coreutils
    inreplace "src/ocaml-output/Makefile", "$(DATE_EXEC) -Iseconds",
                                           "$(DATE_EXEC) '+%Y-%m-%dT%H:%M:%S%z'"

    system "opam", "init", "--no-setup"

    if build.stable?
      system "opam", "install", "batteries=2.5.3", "zarith=1.4.1", "yojson=1.3.3", "pprint=20140424"
    else
      system "opam", "install", "batteries", "zarith", "yojson", "pprint"
    end

    system "opam", "config", "exec", "--", "make", "-C", "src", "boot-ocaml"

    bin.install "bin/fstar.exe"

    (libexec/"stdlib").install Dir["ulib/*"]
    (libexec/"contrib").install Dir["ucontrib/*"]
    (libexec/"examples").install Dir["examples/*"]
    (libexec/"tutorial").install Dir["doc/tutorial/*"]
    (libexec/"src").install Dir["src/*"]
    prefix.install "LICENSE-fsharp.txt"

    prefix.install_symlink libexec/"stdlib"
    prefix.install_symlink libexec/"contrib"
    prefix.install_symlink libexec/"examples"
    prefix.install_symlink libexec/"tutorial"
    prefix.install_symlink libexec/"src"
  end

  def caveats; <<-EOS.undent
    F* code can be extracted to OCaml code.
    To compile the generated OCaml code, you must install the
    package 'batteries' from the Opam package manager:
    - brew install opam
    - opam install batteries

    F* code can be extracted to F# code.
    To compile the generated F# (.NET) code, you must install
    the 'mono' package that includes the fsharp compiler:
    - brew install mono
    EOS
  end

  test do
    system "#{bin}/fstar.exe",
    "--include", "#{prefix}/examples/unit-tests",
    "--admit_fsi", "FStar.Set",
    "FStar.Set.fsi", "FStar.Heap.fst",
    "FStar.ST.fst", "FStar.All.fst",
    "FStar.List.fst", "FStar.String.fst",
    "FStar.Int32.fst", "unit1.fst",
    "unit2.fst", "testset.fst"
  end
end
