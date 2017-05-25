class Fontconfig < Formula
  desc "XML-based font configuration API for X Windows"
  homepage "https://wiki.freedesktop.org/www/Software/fontconfig/"
  revision 2

  stable do
    url "https://www.freedesktop.org/software/fontconfig/release/fontconfig-2.12.1.tar.bz2"
    sha256 "b449a3e10c47e1d1c7a6ec6e2016cca73d3bd68fbbd4f0ae5cc6b573f7d6c7f3"

    patch do
      # Fixes https://bugs.freedesktop.org/show_bug.cgi?id=97546, "fc-cache
      # failure with /System/Library/Fonts", and #4172.
      #
      # Patch from upstream maintainer Akira TAGOH. See
      #   https://bugs.freedesktop.org/show_bug.cgi?id=97546#c7
      #   https://bugs.freedesktop.org/attachment.cgi?id=126464
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/3790bcd/fontconfig/patch-2.12.1-fccache.diff"
      sha256 "e7c074109a367bf3966578034b20d11f7e0b4a611785a040aef1fd11359af04d"
    end
  end

  # The bottle tooling is too lenient and thinks fontconfig
  # is relocatable, but it has hardcoded paths in the executables.
  bottle do
    rebuild 1
    sha256 "c9aa0691856cf65926f3cf0a98437b5a5d31277eda5b3adbf2936e095e410923" => :sierra
    sha256 "65bff1d201c1cf194f69f39d0bc02e8a4c5b1a8cbfafa22f9581501d84835df2" => :el_capitan
    sha256 "da7afd6fc112fc9fe6c2e6b5fa0fec98434ccdaad88c76447e0c741d3c9cd40a" => :yosemite
  end

  pour_bottle? do
    reason "The bottle needs to be installed into /usr/local."
    # c.f. the identical hack in lua
    # https://github.com/Homebrew/homebrew/issues/47173
    satisfy { HOMEBREW_PREFIX.to_s == "/usr/local" }
  end

  head do
    url "https://anongit.freedesktop.org/git/fontconfig", :using => :git

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  keg_only :provided_pre_mountain_lion

  depends_on "pkg-config" => :build
  depends_on "freetype"

  def install
    font_dirs = %w[
      /System/Library/Fonts
      /Library/Fonts
      ~/Library/Fonts
    ]

    if MacOS.version >= :sierra
      font_dirs << "/System/Library/Assets/com_apple_MobileAsset_Font3"
    end

    system "autoreconf", "-iv" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--enable-static",
                          "--with-add-fonts=#{font_dirs.join(",")}",
                          "--prefix=#{prefix}",
                          "--localstatedir=#{var}",
                          "--sysconfdir=#{etc}"
    system "make", "install", "RUN_FC_CACHE_TEST=false"
  end

  def post_install
    ohai "Regenerating font cache, this may take a while"
    system "#{bin}/fc-cache", "-frv"
  end

  test do
    system "#{bin}/fc-list"
  end
end
