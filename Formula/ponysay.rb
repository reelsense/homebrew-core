class Ponysay < Formula
  desc "Cowsay but with ponies"
  homepage "http://erkin.co/ponysay/"
  url "https://github.com/erkin/ponysay/archive/3.0.2.tar.gz"
  sha256 "69e98a7966353de2f232cbdaccd8ef7dbc5d0bcede9bf7280a676793e8625b0d"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "4209ab259798a33086ee4af39fd260b1ed7f6ac3dc9a8b2b44cb9935129f17a5" => :sierra
    sha256 "69e2eb767ee25491e2a30893478bfdeff72023369ad4d9999f4b274e11b732f3" => :el_capitan
    sha256 "157fe5f14e1be281708d2c59987331484c40bd4d49d82c208bb7220503ba113a" => :yosemite
    sha256 "6c8ec0c8031407d5035f6cb7355deed95e6443c7200276ea5419ac31f2db4082" => :mavericks
    sha256 "45f26bc2439d8195651578ceee7f0b5cff318c2ba6b258b0533ce57ba6342ab0" => :mountain_lion
  end

  depends_on :python3
  depends_on "coreutils"

  # fix shell completion install paths
  # https://github.com/erkin/ponysay/pull/225
  patch do
    url "https://github.com/tdsmith/ponysay/commit/44fb0f85821eb34a811abb27d2c601a5d30af1f1.diff?full_index=1"
    sha256 "16f8eb70387bb67fbe7329fad01d5514e6ba5f8ed128af11a9152ab7aa8bf570"
  end

  def install
    system "./setup.py",
           "--freedom=partial",
           "--prefix=#{prefix}",
           "--cache-dir=#{prefix}/var/cache",
           "--sysconf-dir=#{prefix}/etc",
           "install"
  end

  test do
    system "#{bin}/ponysay", "-A"
  end
end
