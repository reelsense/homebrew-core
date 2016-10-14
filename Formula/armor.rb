class Armor < Formula
  desc "Uncomplicated HTTP server, supports HTTP/2 and auto TLS"
  homepage "https://github.com/labstack/armor"
  url "https://github.com/labstack/armor/archive/v0.1.3.tar.gz"
  sha256 "bb90165a70b5ee2e5731b0d626d6cd7abcf8d1bd4e663e67696465dfe217fb42"
  head "https://github.com/labstack/armor.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "7975b9c3f93f7a931ad958706d10620b77f8653acc4c01d891bf7e501ea842e2" => :sierra
    sha256 "de47e9b132754e10588dd78fa1376a39c2f59b00c3a93e78db588c21e88e34b0" => :el_capitan
    sha256 "0cd189df99098d044b0f5a81a451618f95ca3f2b3d7f479a6e7016d4a33bb930" => :yosemite
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    armorpath = buildpath/"src/github.com/labstack/armor"
    armorpath.install buildpath.children

    cd armorpath do
      system "go", "build", "-o", bin/"armor", "cmd/armor/main.go"
      prefix.install_metafiles
    end
  end

  test do
    begin
      pid = fork do
        exec "#{bin}/armor"
      end
      sleep 1
      output = shell_output("curl -sI http://localhost:8080")
      assert_match /200 OK/m, output
    ensure
      Process.kill("HUP", pid)
    end
  end
end
