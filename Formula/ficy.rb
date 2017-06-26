class Ficy < Formula
  desc "Icecast/Shoutcast stream grabber suite"
  homepage "https://www.thregr.org/~wavexx/software/fIcy/"
  url "https://www.thregr.org/~wavexx/software/fIcy/releases/fIcy-1.0.20.tar.gz"
  sha256 "95332bbac323e534dd09c9d43dd7e5a189d916cb3ac31c2b30761743a31c38d6"

  head "https://github.com/wavexx/fIcy.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "84c0a9723612b39cf41b500d45aa9be9b67bcb779ce76983b06b38ae73d435ae" => :sierra
    sha256 "17f8f21f973bb591cc29854c58cc26cc4a5de2550f1b6b02d3d258e67ea9cec9" => :el_capitan
    sha256 "b7f3934b28587731dea3e2bb779f7c498adeec5d3c28e658bb78258b00aca8b0" => :yosemite
  end

  def install
    system "make"
    bin.install "fIcy", "fPls", "fResync"
  end

  test do
    cp test_fixtures("test.mp3"), testpath
    system "#{bin}/fResync", "-n", "1", "test.mp3"
  end
end
