class Llnode < Formula
  desc "LLDB plugin for live/post-mortem debugging of node.js apps"
  homepage "https://github.com/nodejs/llnode"
  url "https://github.com/nodejs/llnode/archive/v1.5.0.tar.gz"
  sha256 "6ef2dbed624f3d6027ad1bc80f5da95c04ef7df3c53c3cc97944f5233c246f9d"

  bottle do
    cellar :any
    sha256 "fae7f5a551caaa8de6eeba4fbbe17d8c6868726176fbbf984cd21b898512d682" => :sierra
    sha256 "6fadddeb27edb56d0e55b88d5315d87081bb8db6d7f6e9523232fc33a713fb1b" => :el_capitan
    sha256 "b924665c84a056f204b910faa339b30c83bcbb734568188777334dea481dbd61" => :yosemite
  end

  depends_on :macos => :yosemite
  depends_on :python => :build

  resource "gyp" do
    url "https://chromium.googlesource.com/external/gyp.git",
        :revision => "db72e9fcf55ba9d8089f0bc7e447180f8972b5c0"
  end

  resource "lldb" do
    if MacOS::Xcode.version >= "8.3"
      # lldb 390
      url "https://github.com/llvm-mirror/lldb.git",
          :revision => "d556e60f02a7404b291d07cac2f27512c73bc743"
    elsif MacOS::Xcode.version >= "8.0"
      # lldb 360.1
      url "https://github.com/llvm-mirror/lldb.git",
          :revision => "839b868e2993dcffc7fea898a1167f1cec097a82"
    else
      # It claims it to be lldb 350.0 for Xcode 7.3, but in fact it is based
      # of 34.
      # Xcode < 7.3 uses 340.4, so I assume we should be safe to go with this.
      url "http://llvm.org/svn/llvm-project/lldb/tags/RELEASE_34/final/",
          :using => :svn
    end
  end

  def install
    (buildpath/"lldb").install resource("lldb")
    (buildpath/"tools/gyp").install resource("gyp")

    system "./gyp_llnode"
    system "make", "-C", "out/"
    prefix.install "out/Release/llnode.dylib"
  end

  def caveats; <<-EOS.undent
    `brew install llnode` does not link the plugin to LLDB PlugIns dir.

    To load this plugin in LLDB, one will need to either

    * Type `plugin load #{opt_prefix}/llnode.dylib` on each run of lldb
    * Install plugin into PlugIns dir manually:

        mkdir -p ~/Library/Application\\ Support/LLDB/PlugIns
        ln -sf #{opt_prefix}/llnode.dylib \\
            ~/Library/Application\\ Support/LLDB/PlugIns/
    EOS
  end

  test do
    lldb_out = pipe_output "lldb", <<-EOS.undent
      plugin load #{opt_prefix}/llnode.dylib
      help v8
      quit
    EOS
    assert_match /v8 bt/, lldb_out
  end
end
