# NOTE: When updating Wine, please check Wine-Gecko and Wine-Mono for updates
# too:
#  - https://wiki.winehq.org/Gecko
#  - https://wiki.winehq.org/Mono
class Wine < Formula
  desc "Run Windows applications without a copy of Microsoft Windows"
  homepage "https://www.winehq.org/"
  head "git://source.winehq.org/git/wine.git"

  stable do
    url "https://dl.winehq.org/wine/source/1.8/wine-1.8.3.tar.bz2"
    mirror "https://downloads.sourceforge.net/project/wine/Source/wine-1.8.3.tar.bz2"
    sha256 "d7cecdf7aab93bfe950e6f83ec526681b8770788c7b2a802bfe50ff97fc17a6c"

    # Patch to fix screen-flickering issues. Still relevant on 1.8. Broken on 1.9.10.
    # https://bugs.winehq.org/show_bug.cgi?id=34166
    patch do
      url "https://bugs.winehq.org/attachment.cgi?id=52485"
      sha256 "59f1831a1b49c1b7a4c6e6af7e3f89f0bc60bec0bead645a615b251d37d232ac"
    end

    # Fixes build on 10.12; included in the latest devel release already
    # https://bugs.winehq.org/show_bug.cgi?id=40830
    patch do
      url "https://github.com/wine-mirror/wine/commit/cac226200d88b7454747b5ee1016f06b89ce4aa6.patch"
      sha256 "ad5dd3aff4dd03aa6dd9e00162a52ad335dbd9ddb5a4472ad8533efb677fb479"
    end

    # Fixes a CUPS-related build failure
    # https://bugs.winehq.org/show_bug.cgi?id=40851
    if MacOS.version >= :sierra
      patch do
        url "https://bugs.winehq.org/attachment.cgi?id=54854"
        sha256 "07da01c4141052d274dbe39d45a13568265cbdcbc9de4f6e80f4eeb08aad9ff8"
      end
    end
  end

  bottle do
    sha256 "5f09c0c48299895929a2816ddef0c7d430d9ae36b617996be99330a24f290dc1" => :el_capitan
    sha256 "d7923a5b6f57c9410ac63f03b2769f832f69413f7db7268dc57be6968541394e" => :yosemite
    sha256 "e1594c0d42c14a01b422b3c657aa93dc066a78b8f03e9864a1a3e761bf13a583" => :mavericks
  end

  devel do
    url "https://dl.winehq.org/wine/source/1.9/wine-1.9.16.tar.bz2"
    mirror "https://downloads.sourceforge.net/project/wine/Source/wine-1.9.16.tar.bz2"
    sha256 "e120d6673aada93935c6661b75c2edc835a45a8e658b80934c36434b56940f04"
  end

  # note that all wine dependencies should declare a --universal option in their formula,
  # otherwise homebrew will not notice that they are not built universal
  def require_universal_deps?
    MacOS.prefer_64_bit?
  end

  # Wine will build both the Mac and the X11 driver by default, and you can switch
  # between them. But if you really want to build without X11, you can.
  depends_on :x11 => :recommended
  depends_on "pkg-config" => :build
  depends_on "freetype"
  depends_on "jpeg"
  depends_on "libgphoto2"
  depends_on "little-cms2"
  depends_on "libicns"
  depends_on "libtiff"
  depends_on "sane-backends"
  depends_on "gnutls"
  depends_on "libgsm" => :optional

  # Patch to fix texture compression issues. Still relevant on 1.8.
  # https://bugs.winehq.org/show_bug.cgi?id=14939
  patch do
    url "https://bugs.winehq.org/attachment.cgi?id=52384"
    sha256 "30766403f5064a115f61de8cacba1defddffe2dd898b59557956400470adc699"
  end

  # This option is currently disabled because Apple clang currently doesn't
  # support a required feature: https://reviews.llvm.org/D1623
  # It builds fine with GCC, however.
  # option "with-win64",
  #        "Build with win64 emulator (won't run 32-bit binaries.)"

  resource "gecko" do
    url "https://downloads.sourceforge.net/wine/wine_gecko-2.40-x86.msi", :using => :nounzip
    sha256 "1a29d17435a52b7663cea6f30a0771f74097962b07031947719bb7b46057d302"
  end

  resource "mono" do
    url "https://downloads.sourceforge.net/wine/wine-mono-4.5.6.msi", :using => :nounzip
    sha256 "ac681f737f83742d786706529eb85f4bc8d6bdddd8dcdfa9e2e336b71973bc25"
  end

  fails_with :llvm do
    build 2336
    cause "llvm-gcc does not respect force_align_arg_pointer"
  end

  fails_with :clang do
    build 425
    cause "Clang prior to Xcode 5 miscompiles some parts of wine"
  end

  # These libraries are not specified as dependencies, or not built as 32-bit:
  # configure: libv4l, gstreamer-0.10, libcapi20, libgsm

  # Wine loads many libraries lazily using dlopen calls, so it needs these paths
  # to be searched by dyld.
  # Including /usr/lib because wine, as of 1.3.15, tries to dlopen
  # libncurses.5.4.dylib, and fails to find it without the fallback path.

  def library_path
    paths = %W[#{HOMEBREW_PREFIX}/lib /usr/lib]
    paths.unshift(MacOS::X11.lib) if build.with? "x11"
    paths.join(":")
  end

  def wine_wrapper; <<-EOS.undent
    #!/bin/sh
    DYLD_FALLBACK_LIBRARY_PATH="#{library_path}" "#{bin}/wine.bin" "$@"
    EOS
  end

  def install
    ENV.m32 # Build 32-bit; Wine doesn't support 64-bit host builds on OS X.

    # Help configure find libxml2 in an XCode only (no CLT) installation.
    ENV.libxml2

    args = ["--prefix=#{prefix}"]
    args << "--disable-win16" if MacOS.version <= :leopard
    args << "--enable-win64" if build.with? "win64"

    # 64-bit builds of mpg123 are incompatible with 32-bit builds of Wine
    args << "--without-mpg123" if Hardware::CPU.is_64_bit?

    args << "--without-x" if build.without? "x11"

    system "./configure", *args

    # The Mac driver uses blocks and must be compiled with an Apple compiler
    # even if the rest of Wine is built with A GNU compiler.
    unless ENV.compiler == :clang || ENV.compiler == :llvm || ENV.compiler == :gcc
      system "make", "dlls/winemac.drv/Makefile"
      inreplace "dlls/winemac.drv/Makefile" do |s|
        # We need to use the real compiler, not the superenv shim, which will exec the
        # configured compiler no matter what name is used to invoke it.
        cc = s.get_make_var("CC")
        cxx = s.get_make_var("CXX")
        s.change_make_var! "CC", cc.sub(ENV.cc, "xcrun clang") if cc
        s.change_make_var! "CXX", cc.sub(ENV.cxx, "xcrun clang++") if cxx

        # Emulate some things that superenv would normally handle for us
        # Pass the sysroot to support Xcode-only systems
        cflags  = s.get_make_var("CFLAGS")
        cflags += " --sysroot=#{MacOS.sdk_path}"
        s.change_make_var! "CFLAGS", cflags
      end
    end

    system "make", "install"
    (pkgshare/"gecko").install resource("gecko")
    (pkgshare/"mono").install resource("mono")

    # Use a wrapper script, so rename wine to wine.bin
    # and name our startup script wine
    mv bin/"wine", bin/"wine.bin"
    (bin/"wine").write(wine_wrapper)
  end

  def caveats
    s = <<-EOS.undent
      You may want to get winetricks:
        brew install winetricks
    EOS

    if build.with? "x11"
      s += <<-EOS.undent

        By default Wine uses a native Mac driver. To switch to the X11 driver, use
        regedit to set the "graphics" key under "HKCU\Software\Wine\Drivers" to
        "x11" (or use winetricks).

        For best results with X11, install the latest version of XQuartz:
          https://xquartz.macosforge.org/
      EOS
    end
    s
  end

  test do
    system "#{bin}/wine", "--version"
  end
end
