class Direnv < Formula
  desc "Load/unload environment variables based on $PWD"
  homepage "https://direnv.net/"
  url "https://github.com/direnv/direnv/archive/2.13.0.tar.gz"
  sha256 "e95452b93b94f7f39b82064dcf21c77ceecd6ccc1e18d282eb43bb2b188f0943"
  head "https://github.com/direnv/direnv.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "57dd8105b64321a4470e15facc4aeed27386756bd1193cd050a79dbd6fc148a1" => :high_sierra
    sha256 "9937102428c968d1faad5863a0f9236e338e39407ebefce2b99234cdfce1edf4" => :sierra
    sha256 "ca47a20f518f7029dc3222440ab7096a1fbbffb6fa2c19d38447c44780386386" => :el_capitan
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/direnv/direnv").install buildpath.children
    cd "src/github.com/direnv/direnv" do
      system "make", "install", "DESTDIR=#{prefix}"
      prefix.install_metafiles
    end
  end

  test do
    system bin/"direnv", "status"
  end
end
