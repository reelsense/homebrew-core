class Radamsa < Formula
  desc "Test case generator for robustness testing (a.k.a. a \"fuzzer\")"
  homepage "https://code.google.com/p/ouspg/wiki/Radamsa"
  url "https://ouspg.googlecode.com/files/radamsa-0.3.tar.gz"
  sha256 "17131a19fb28e5c97c28bf0b407a82744c251aa8aedfa507967a92438cd803be"

  bottle do
    cellar :any_skip_relocation
    sha256 "44569c384623b1419a5431a8ba9c48743854bfb3ea79e3736bb1ad63d1fe04a1" => :el_capitan
    sha256 "184f9a9d1c030ab7ee83b84236f3749e1d3e0de11214166b264c4f52af902fc6" => :yosemite
    sha256 "fd10a5879e5d80d0decfc10b96a9a2bdbdbb3ce667b030a51ff152566020353b" => :mavericks
  end

  def install
    system "make"
    man1.install "doc/radamsa.1"
    prefix.install Dir["*"]
  end

  def caveats; <<-EOS.undent
    The Radamsa binary has been installed.
    The Lisp source code has been copied to:
      #{prefix}/rad

    To be able to recompile the source to C, you will need run:
      $ make get-owl

    Tests can be run with:
      $ make .seal-of-quality

    EOS
  end

  test do
    system bin/"radamsa", "-V"
  end
end
