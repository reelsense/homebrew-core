class Micro < Formula
  desc "Modern and intuitive terminal-based text editor"
  homepage "https://github.com/zyedidia/micro"
  url "https://github.com/zyedidia/micro/releases/download/v1.3.2/micro-1.3.2-src.tar.gz"
  sha256 "1a08301e39353914d7e699e36455bac1fee7d6d5ff1e211499bc10b46d8b35f5"
  head "https://github.com/zyedidia/micro.git", :shallow => false

  bottle do
    cellar :any_skip_relocation
    sha256 "4ae12596d98d78dc8e4dea32b6d70ebbf3d38d256279cc2adf787c1663166d69" => :high_sierra
    sha256 "c0e761c64b14fa778327f3c637e78a8b7bccfadd0373ca837a3d389366b10672" => :sierra
    sha256 "4b5eafa110e762c35cc07d9892801af9dd192b9f549267b7157940df668930de" => :el_capitan
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    (buildpath/"src/github.com/zyedidia/micro").install buildpath.children

    cd "src/github.com/zyedidia/micro" do
      system "make", "build-quick"
      bin.install "micro"
      prefix.install_metafiles
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/micro -version")
  end
end
