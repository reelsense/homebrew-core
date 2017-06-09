class GitTown < Formula
  desc "High-level command-line interface for Git"
  homepage "http://www.git-town.com"
  url "https://github.com/Originate/git-town/archive/v4.1.2.tar.gz"
  sha256 "0f1b443196b33abf67ea103336213dbbe2df4d0ed384b66b610f95c6d6dd17bc"

  bottle do
    cellar :any_skip_relocation
    sha256 "98bdd78e94ac7f610e7c73cb4a839bc71e2176a62d5b027a50e34cb0f9418ebf" => :sierra
    sha256 "d43d27ae0fffcc869278a19b48f35c67c3193c46e032bc0b0c2c4027f593a987" => :el_capitan
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
