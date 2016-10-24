# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  desc "Download YouTube videos from the command-line"
  homepage "https://rg3.github.io/youtube-dl/"
  url "https://github.com/rg3/youtube-dl/releases/download/2016.10.21.1/youtube-dl-2016.10.21.1.tar.gz"
  sha256 "8b768ad99ecdbc08521171456800515df29df8bceb0f1fe1cb8113dd2500d216"

  bottle do
    cellar :any_skip_relocation
    sha256 "2010cdab92e30986281287514e0d87da3aef87bdaaf7b0ac5a3ca469f0424a53" => :sierra
    sha256 "2010cdab92e30986281287514e0d87da3aef87bdaaf7b0ac5a3ca469f0424a53" => :el_capitan
    sha256 "2010cdab92e30986281287514e0d87da3aef87bdaaf7b0ac5a3ca469f0424a53" => :yosemite
  end

  head do
    url "https://github.com/rg3/youtube-dl.git"
    depends_on "pandoc" => :build
  end

  depends_on "rtmpdump" => :optional

  def install
    system "make", "PREFIX=#{prefix}"
    bin.install "youtube-dl"
    man1.install "youtube-dl.1"
    bash_completion.install "youtube-dl.bash-completion"
    zsh_completion.install "youtube-dl.zsh" => "_youtube-dl"
    fish_completion.install "youtube-dl.fish"
  end

  def caveats
    "To use post-processing options, `brew install ffmpeg` or `brew install libav`."
  end

  test do
    system "#{bin}/youtube-dl", "--simulate", "https://www.youtube.com/watch?v=he2a4xK8ctk"
    system "#{bin}/youtube-dl", "--simulate", "--yes-playlist", "https://www.youtube.com/watch?v=AEhULv4ruL4&list=PLZdCLR02grLrl5ie970A24kvti21hGiOf"
  end
end
