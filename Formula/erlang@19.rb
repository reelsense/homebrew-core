class ErlangAT19 < Formula
  desc "Programming language for highly scalable real-time systems"
  homepage "https://www.erlang.org/"
  # Download tarball from GitHub; it is served faster than the official tarball.
  url "https://github.com/erlang/otp/archive/OTP-19.3.tar.gz"
  sha256 "fc82c5377ad9e84a37f67f2b2b50b27fe4e689440ae9e5d0f5dcfb440a9487ac"
  head "https://github.com/erlang/otp.git", :branch => "maint-19"

  bottle do
    cellar :any
    sha256 "fd97e5741bbac1136596779687bf78ecb6ac5fa043f015a2d804635a0388c0d3" => :sierra
    sha256 "77a0d9fce165ef1630b4d7c3e4e87df013b3d4c2a40fc0ba3bb69324a12dcb39" => :el_capitan
    sha256 "4c9003f1747f9fc9ce2bc53e4a6d30dfb9cc6a7c58bb9be5fed211c1fc3622be" => :yosemite
  end

  keg_only :versioned_formula

  option "without-hipe", "Disable building hipe; fails on various macOS systems"
  option "with-native-libs", "Enable native library compilation"
  option "with-dirty-schedulers", "Enable experimental dirty schedulers"
  option "with-java", "Build jinterface application"
  option "without-docs", "Do not install documentation"

  deprecated_option "disable-hipe" => "without-hipe"
  deprecated_option "no-docs" => "without-docs"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "openssl"
  depends_on "fop" => :optional # enables building PDF docs
  depends_on :java => :optional
  depends_on "wxmac" => :recommended # for GUI apps like observer

  resource "man" do
    url "https://www.erlang.org/download/otp_doc_man_19.3.tar.gz"
    mirror "https://www.mirrorservice.org/sites/ftp.netbsd.org/pub/pkgsrc/distfiles/erlang/otp_doc_man_19.3.tar.gz"
    sha256 "f8192ffdd7367083c055695eeddf198155da43dcc221aed1d870d1e3871dd95c"
  end

  resource "html" do
    url "https://www.erlang.org/download/otp_doc_html_19.3.tar.gz"
    mirror "https://www.mirrorservice.org/sites/ftp.netbsd.org/pub/pkgsrc/distfiles/erlang/otp_doc_html_19.3.tar.gz"
    sha256 "dc3e3a82d1aba7f0deac1ddb81b7d6f8dee9a75e1d42b90c677a2b645f19a00c"
  end

  def install
    # Unset these so that building wx, kernel, compiler and
    # other modules doesn't fail with an unintelligable error.
    %w[LIBS FLAGS AFLAGS ZFLAGS].each { |k| ENV.delete("ERL_#{k}") }

    ENV["FOP"] = "#{HOMEBREW_PREFIX}/bin/fop" if build.with? "fop"

    # Do this if building from a checkout to generate configure
    system "./otp_build", "autoconf" if File.exist? "otp_build"

    args = %W[
      --disable-debug
      --disable-silent-rules
      --prefix=#{prefix}
      --enable-kernel-poll
      --enable-threads
      --enable-sctp
      --enable-dynamic-ssl-lib
      --with-ssl=#{Formula["openssl"].opt_prefix}
      --enable-shared-zlib
      --enable-smp-support
    ]

    args << "--enable-darwin-64bit" if MacOS.prefer_64_bit?
    args << "--enable-native-libs" if build.with? "native-libs"
    args << "--enable-dirty-schedulers" if build.with? "dirty-schedulers"
    args << "--enable-wx" if build.with? "wxmac"
    args << "--with-dynamic-trace=dtrace" if MacOS::CLT.installed?

    if build.without? "hipe"
      # HIPE doesn't strike me as that reliable on macOS
      # https://syntatic.wordpress.com/2008/06/12/macports-erlang-bus-error-due-to-mac-os-x-1053-update/
      # https://www.erlang.org/pipermail/erlang-patches/2008-September/000293.html
      args << "--disable-hipe"
    else
      args << "--enable-hipe"
    end

    if build.with? "java"
      args << "--with-javac"
    else
      args << "--without-javac"
    end

    system "./configure", *args
    system "make"
    system "make", "install"

    if build.with? "docs"
      (lib/"erlang").install resource("man").files("man")
      doc.install resource("html")
    end
  end

  def caveats; <<-EOS.undent
    Man pages can be found in:
      #{opt_lib}/erlang/man
    Access them with `erl -man`, or add this directory to MANPATH.
    EOS
  end

  test do
    system "#{bin}/erl", "-noshell", "-eval", "crypto:start().", "-s", "init", "stop"
  end
end
