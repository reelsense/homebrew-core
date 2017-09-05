class Entr < Formula
  desc "Run arbitrary commands when files change"
  homepage "http://entrproject.org/"
  url "http://entrproject.org/code/entr-3.8.tar.gz"
  mirror "https://bitbucket.org/eradman/entr/get/entr-3.8.tar.gz"
  sha256 "ebb1e793d948db76481f081011bf1dad8b4449e067f4e5fe68176191f84b26bd"

  bottle do
    cellar :any_skip_relocation
    sha256 "eefae48abeb986b3d0f4f60b4090bf85c86249efb42ad3a70ad65c6f690ef7af" => :sierra
    sha256 "65b4a69116adedd4b3f1677f1d2946f12d31a117527439c2eacbeff746fab7eb" => :el_capitan
    sha256 "acfa5e389ca6b0d29f3a3a62abd9f585af12b9f3edb96bb902e76badd3dcfa00" => :yosemite
  end

  head do
    url "https://bitbucket.org/eradman/entr", :using => :hg
    depends_on :hg => :build
  end

  def install
    ENV["PREFIX"] = prefix
    ENV["MANPREFIX"] = man
    system "./configure"
    system "make"
    system "make", "install"
  end

  test do
    touch testpath/"test.1"
    fork do
      sleep 0.5
      touch testpath/"test.2"
    end
    assert_equal "New File", pipe_output("#{bin}/entr -p -d echo 'New File'", testpath).strip
  end
end
