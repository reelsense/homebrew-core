class GitTown < Formula
  desc "High-level command-line interface for Git"
  homepage "http://www.git-town.com"
  url "https://github.com/Originate/git-town/archive/v4.1.0.tar.gz"
  sha256 "1fa52580a1c162da28f0530e455379c9ac7bd7663507497c70ac9aa90680f30a"

  bottle do
    cellar :any_skip_relocation
    sha256 "0ba4f2ce23b5d1af0f2fde46e8653d34ed4261c3f3ef37ac86a0da7654483faf" => :sierra
    sha256 "9e6358a9f544e7da1288dc5777df8c1058a79acac6fb4863e337e06993855ed3" => :el_capitan
  end

  depends_on "go" => :build
  depends_on :macos => :el_capitan

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/Originate").mkpath
    ln_sf buildpath, buildpath/"src/github.com/Originate/git-town"
    system "go", "build", "-o", bin/"git-town"
  end

  test do
    system "git", "init"
    touch "testing.txt"
    system "git", "add", "testing.txt"
    system "git", "commit", "-m", "Testing!"

    system "#{bin}/git-town", "config"
  end
end
