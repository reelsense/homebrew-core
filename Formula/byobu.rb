class Byobu < Formula
  desc "Text-based window manager and terminal multiplexer"
  homepage "http://byobu.co"
  url "https://launchpad.net/byobu/trunk/5.114/+download/byobu_5.114.orig.tar.gz"
  sha256 "eb079962d31b52129b3b064fb499639f3e3c6bda53deddbdb8629a298651ffc7"

  bottle do
    cellar :any_skip_relocation
    sha256 "b3db11c9f0f224c39ddbbda336a7168d54e654f54a68f766170ac85701a44b3b" => :sierra
    sha256 "a82a96ba0617e6e0fb44807f1591d638863bc48e548be30240fd23bf896911f1" => :el_capitan
    sha256 "a82a96ba0617e6e0fb44807f1591d638863bc48e548be30240fd23bf896911f1" => :yosemite
  end

  head do
    url "https://github.com/dustinkirkland/byobu.git"

    depends_on "automake" => :build
    depends_on "autoconf" => :build
  end

  depends_on "coreutils"
  depends_on "gnu-sed" # fails with BSD sed
  depends_on "tmux"
  depends_on "newt"

  conflicts_with "ctail", :because => "both install `ctail` binaries"

  def install
    if build.head?
      cp "./debian/changelog", "./ChangeLog"
      system "autoreconf", "-fvi"
    end
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  def caveats; <<-EOS.undent
    Add the following to your shell configuration file:
      export BYOBU_PREFIX=#{HOMEBREW_PREFIX}
    EOS
  end

  test do
    system bin/"byobu-status"
  end
end
