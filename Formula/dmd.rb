class Dmd < Formula
  desc "D programming language compiler for macOS"
  homepage "https://dlang.org/"

  stable do
    url "https://github.com/dlang/dmd/archive/v2.072.2.tar.gz"
    sha256 "ffb1fd593b7f8c0120c4519b0e60c1029948544d60e6d0166523410687373e23"

    resource "druntime" do
      url "https://github.com/dlang/druntime/archive/v2.072.2.tar.gz"
      sha256 "49a9f1295f887bb4edb686d689044ddfa86e8522a9848d6bb4e41f5198907183"
    end

    resource "phobos" do
      url "https://github.com/dlang/phobos/archive/v2.072.2.tar.gz"
      sha256 "fa110766b8e3acebf4c316e78fca6d61d2a3cf03c13f23ed1833f4869ed72769"
    end

    resource "tools" do
      url "https://github.com/dlang/tools/archive/v2.072.2.tar.gz"
      sha256 "2cfbaaa1736d21a5225ad43015366cc12f4e86805d1287ef3ffbd5b36aefc738"
    end
  end

  bottle do
    sha256 "f5307872239e65a99cd9bc8b52e9a1b81d0dca6c53f1a538ad0dd04b9af59456" => :sierra
    sha256 "1f8a65f1d7ad78fb62387284c7376603299d2fea2c9efec307d450fd7201fd1a" => :el_capitan
    sha256 "d3bba0028f81d71df83f7f02cce8c61f530b32a1d0a1bfb0be035c58bb6c6ec2" => :yosemite
  end

  head do
    url "https://github.com/dlang/dmd.git"

    resource "druntime" do
      url "https://github.com/dlang/druntime.git"
    end

    resource "phobos" do
      url "https://github.com/dlang/phobos.git"
    end

    resource "tools" do
      url "https://github.com/dlang/tools.git"
    end
  end

  def install
    make_args = ["INSTALL_DIR=#{prefix}", "MODEL=#{Hardware::CPU.bits}", "-f", "posix.mak"]

    system "make", "SYSCONFDIR=#{etc}", "TARGET_CPU=X86", "AUTO_BOOTSTRAP=1", "RELEASE=1", *make_args

    bin.install "src/dmd"
    prefix.install "samples"
    man.install Dir["docs/man/*"]

    # A proper dmd.conf is required for later build steps:
    conf = buildpath/"dmd.conf"
    # Can't use opt_include or opt_lib here because dmd won't have been
    # linked into opt by the time this build runs:
    conf.write <<-EOS.undent
        [Environment]
        DFLAGS=-I#{include}/dlang/dmd -L-L#{lib}
        EOS
    etc.install conf
    install_new_dmd_conf

    make_args.unshift "DMD=#{bin}/dmd"

    (buildpath/"druntime").install resource("druntime")
    (buildpath/"phobos").install resource("phobos")

    system "make", "-C", "druntime", *make_args
    system "make", "-C", "phobos", "VERSION=#{buildpath}/VERSION", *make_args

    (include/"dlang/dmd").install Dir["druntime/import/*"]
    cp_r ["phobos/std", "phobos/etc"], include/"dlang/dmd"
    lib.install Dir["druntime/lib/*", "phobos/**/libphobos2.a"]

    resource("tools").stage do
      inreplace "posix.mak", "install: $(TOOLS) $(CURL_TOOLS)", "install: $(TOOLS) $(ROOT)/dustmite"
      system "make", "install", *make_args
    end
  end

  # Previous versions of this formula may have left in place an incorrect
  # dmd.conf.  If it differs from the newly generated one, move it out of place
  # and warn the user.
  # This must be idempotent because it may run from both install() and
  # post_install() if the user is running `brew install --build-from-source`.
  def install_new_dmd_conf
    conf = etc/"dmd.conf"

    # If the new file differs from conf, etc.install drops it here:
    new_conf = etc/"dmd.conf.default"
    # Else, we're already using the latest version:
    return unless new_conf.exist?

    backup = etc/"dmd.conf.old"
    opoo "An old dmd.conf was found and will be moved to #{backup}."
    mv conf, backup
    mv new_conf, conf
  end

  def post_install
    install_new_dmd_conf
  end

  test do
    system bin/"dmd", prefix/"samples/hello.d"
    system "./hello"
  end
end
