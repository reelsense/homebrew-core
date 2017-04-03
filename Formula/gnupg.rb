class Gnupg < Formula
  desc "GNU Pretty Good Privacy (PGP) package"
  homepage "https://www.gnupg.org/"
  url "https://gnupg.org/ftp/gcrypt/gnupg/gnupg-2.1.19.tar.bz2"
  mirror "https://www.mirrorservice.org/sites/ftp.gnupg.org/gcrypt/gnupg/gnupg-2.1.19.tar.bz2"
  sha256 "46cced1f5641ce29cc28250f52fadf6e417e649b3bfdec49a5a0d0b22a639bf0"

  bottle do
    sha256 "489c79922a572a68b98c8dcf3e55a657a8c745fd1e02a1b2b42aa781b1f07d91" => :sierra
    sha256 "153fed441e24dbd501b338cd3872a9aeaabf646275aeae82d8172ef29e8d6802" => :el_capitan
    sha256 "df23cf948ad165e8370d2617ca7ec3a90d583e220a1af00335b9e93fa57fa586" => :yosemite
  end

  option "with-gpgsplit", "Additionally install the gpgsplit utility"
  option "without-libusb", "Disable the internal CCID driver"

  deprecated_option "without-libusb-compat" => "without-libusb"

  depends_on "pkg-config" => :build
  depends_on "sqlite" => :build if MacOS.version == :mavericks
  depends_on "npth"
  depends_on "gnutls"
  depends_on "libgpg-error"
  depends_on "libgcrypt"
  depends_on "libksba"
  depends_on "libassuan"
  depends_on "pinentry"
  depends_on "gettext"
  depends_on "adns"
  depends_on "libusb" => :recommended
  depends_on "readline" => :optional
  depends_on "homebrew/fuse/encfs" => :optional

  # Remove for > 2.1.19
  # ssh-import.scm fails during "make check" for sandboxed builds
  # Reported 1 Mar 2017 https://bugs.gnupg.org/gnupg/issue2980
  # Fixed 6 Mar 2017 in https://git.gnupg.org/cgi-bin/gitweb.cgi?p=gnupg.git;a=patch;h=4ce4f2f683a17be3ddb93729f3f25014a97934ad
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/c0c54c6/gnupg/agent-handle-scdaemon-errors.patch"
    sha256 "c2de625327c14b2c0538f45749f46c67169598c879dc81cf828bbb30677b7e59"
  end

  # Remove for > 2.1.19
  # "make check" cannot run before "make install"
  # Reported 1 Mar 2017 https://bugs.gnupg.org/gnupg/issue2979
  # Fixed 15 Mar 2017 in https://git.gnupg.org/cgi-bin/gitweb.cgi?p=gnupg.git;a=patch;h=a98459d3f4ec3d196fb0adb0e90dadf40abc8c81
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/f234026/gnupg/fix-using-tools-from-build-dir.patch"
    sha256 "f36614537c75981c448d4c8b78e6040a40f867464c7828ed72a91a35cd2b577f"
  end

  def install
    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --sbindir=#{bin}
      --sysconfdir=#{etc}
      --enable-symcryptrun
      --with-pinentry-pgm=#{Formula["pinentry"].opt_bin}/pinentry
    ]

    args << "--disable-ccid-driver" if build.without? "libusb"
    args << "--with-readline=#{Formula["readline"].opt_prefix}" if build.with? "readline"

    system "./configure", *args
    system "make"
    system "make", "check"
    system "make", "install"

    # Add symlinks from gpg2 to unversioned executables, replacing gpg 1.x.
    bin.install_symlink "gpg2" => "gpg"
    bin.install_symlink "gpgv2" => "gpgv"
    man1.install_symlink "gpg2.1" => "gpg.1"
    man1.install_symlink "gpgv2.1" => "gpgv.1"

    bin.install "tools/gpgsplit" => "gpgsplit2" if build.with? "gpgsplit"
  end

  def post_install
    (var/"run").mkpath
    quiet_system "killall", "gpg-agent"
  end

  def caveats; <<-EOS.undent
    Once you run this version of gpg you may find it difficult to return to using
    a prior 1.4.x or 2.0.x. Most notably the prior versions will not automatically
    know about new secret keys created or imported by this version. We recommend
    creating a backup of your `~/.gnupg` prior to first use.

    For full details on each change and how it could impact you please see
      https://www.gnupg.org/faq/whats-new-in-2.1.html
    EOS
  end

  test do
    (testpath/"batch.gpg").write <<-EOS.undent
      Key-Type: RSA
      Key-Length: 2048
      Subkey-Type: RSA
      Subkey-Length: 2048
      Name-Real: Testing
      Name-Email: testing@foo.bar
      Expire-Date: 1d
      %no-protection
      %commit
    EOS
    begin
      system bin/"gpg", "--batch", "--gen-key", "batch.gpg"
      (testpath/"test.txt").write "Hello World!"
      system bin/"gpg", "--detach-sign", "test.txt"
      system bin/"gpg", "--verify", "test.txt.sig"
    ensure
      system bin/"gpgconf", "--kill", "gpg-agent"
    end
  end
end
