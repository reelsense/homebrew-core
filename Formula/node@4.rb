class NodeAT4 < Formula
  desc "Platform built on V8 to build network applications"
  homepage "https://nodejs.org/"
  url "https://nodejs.org/dist/v4.7.2/node-v4.7.2.tar.xz"
  sha256 "ad1b8309a621f725b5d8205f0fc5bbb7b396a438c108e6fba417c1a914932dfc"
  head "https://github.com/nodejs/node.git", :branch => "v4.x-staging"

  bottle do
    sha256 "9bfbf45f8c1d1aa63d2556ca69e878634fc701df7a730b99f5f6f748b27a55b0" => :sierra
    sha256 "8d3026205953ed0b56b942771ff978aac2eb8c56e3a2a588e69bcbbd76986045" => :el_capitan
    sha256 "b8415cde68f9d17ee92394b857423b0c1d1a4ffbff361c4e1df1823d5c366983" => :yosemite
  end

  option "with-debug", "Build with debugger hooks"
  option "without-npm", "npm will not be installed"
  option "without-completion", "npm bash completion will not be installed"
  option "with-full-icu", "Build with full-icu (all locales) instead of small-icu (English only)"

  depends_on :python => :build if MacOS.version <= :snow_leopard
  depends_on "pkg-config" => :build
  depends_on "openssl" => :optional

  conflicts_with "node", :because => "Differing versions of the same formula"
  conflicts_with "node@0.10", :because => "Differing versions of the same formulae."
  conflicts_with "node@0.12", :because => "Differing versions of the same formulae."
  conflicts_with "node@5", :because => "Differing versions of the same formulae."
  conflicts_with "node@6", :because => "Differing versions of the same formulae."

  resource "npm" do
    url "https://registry.npmjs.org/npm/-/npm-2.15.11.tgz"
    sha256 "927974142c9a44e9bd879d9e9762e7de379b43c5acfae32b02b44f60e59a9c9c"
  end

  resource "icu4c" do
    url "https://ssl.icu-project.org/files/icu4c/56.1/icu4c-56_1-src.tgz"
    version "56.1"
    sha256 "3a64e9105c734dcf631c0b3ed60404531bce6c0f5a64bfe1a6402a4cc2314816"
  end

  def install
    args = %W[--prefix=#{prefix} --without-npm]
    args << "--debug" if build.with? "debug"
    args << "--shared-openssl" if build.with? "openssl"

    if build.with? "full-icu"
      args << "--with-intl=full-icu"
    else
      args << "--with-intl=small-icu"
    end
    args << "--tag=head" if build.head?

    resource("icu4c").stage buildpath/"deps/icu"

    system "./configure", *args
    system "make", "install"

    if build.with? "npm"
      resource("npm").stage buildpath/"npm_install"

      # make sure npm can find node
      ENV.prepend_path "PATH", bin
      # set log level temporarily for npm's `make install`
      ENV["NPM_CONFIG_LOGLEVEL"] = "verbose"
      # unset prefix temporarily for npm's `make install`
      ENV.delete "NPM_CONFIG_PREFIX"

      cd buildpath/"npm_install" do
        system "./configure", "--prefix=#{libexec}/npm"
        system "make", "install"
        # `package.json` has relative paths to the npm_install directory.
        # This copies back over the vanilla `package.json` that is expected.
        # https://github.com/Homebrew/homebrew/issues/46131#issuecomment-157845008
        cp buildpath/"npm_install/package.json", libexec/"npm/lib/node_modules/npm"
        # Remove manpage symlinks from the buildpath, they are breaking bottle
        # creation. The real manpages are living in libexec/npm/lib/node_modules/npm/man/
        # https://github.com/Homebrew/homebrew/pull/47081#issuecomment-165280470
        rm_rf libexec/"npm/share/"
      end

      if build.with? "completion"
        bash_completion.install \
          buildpath/"npm_install/lib/utils/completion.sh" => "npm"
      end
    end
  end

  def post_install
    return if build.without? "npm"

    node_modules = HOMEBREW_PREFIX/"lib/node_modules"
    node_modules.mkpath
    npm_exec = node_modules/"npm/bin/npm-cli.js"
    # Kill npm but preserve all other modules across node updates/upgrades.
    rm_rf node_modules/"npm"

    cp_r libexec/"npm/lib/node_modules/npm", node_modules
    # This symlink doesn't hop into homebrew_prefix/bin automatically so
    # remove it and make our own. This is a small consequence of our bottle
    # npm make install workaround. All other installs **do** symlink to
    # homebrew_prefix/bin correctly. We ln rather than cp this because doing
    # so mimics npm's normal install.
    ln_sf npm_exec, "#{HOMEBREW_PREFIX}/bin/npm"

    # Let's do the manpage dance. It's just a jump to the left.
    # And then a step to the right, with your hand on rm_f.
    ["man1", "man3", "man5", "man7"].each do |man|
      # Dirs must exist first: https://github.com/Homebrew/homebrew/issues/35969
      mkdir_p HOMEBREW_PREFIX/"share/man/#{man}"
      rm_f Dir[HOMEBREW_PREFIX/"share/man/#{man}/{npm.,npm-,npmrc.,package.json.}*"]
      ln_sf Dir[libexec/"npm/lib/node_modules/npm/man/#{man}/{npm,package.json}*"], HOMEBREW_PREFIX/"share/man/#{man}"
    end

    npm_root = node_modules/"npm"
    npmrc = npm_root/"npmrc"
    npmrc.atomic_write("prefix = #{HOMEBREW_PREFIX}\n")
  end

  def caveats
    s = ""

    if build.without? "npm"
      s += <<-EOS.undent
        Homebrew has NOT installed npm. If you later install it, you should supplement
        your NODE_PATH with the npm module folder:
          #{HOMEBREW_PREFIX}/lib/node_modules
      EOS
    end

    s
  end

  test do
    path = testpath/"test.js"
    path.write "console.log('hello');"

    output = shell_output("#{bin}/node #{path}").strip
    assert_equal "hello", output
    output = shell_output("#{bin}/node -e 'console.log(new Intl.NumberFormat(\"en-EN\").format(1234.56))'").strip
    assert_equal "1,234.56", output

    if build.with? "npm"
      # make sure npm can find node
      ENV.prepend_path "PATH", opt_bin
      ENV.delete "NVM_NODEJS_ORG_MIRROR"
      assert_equal which("node"), opt_bin/"node"
      assert (HOMEBREW_PREFIX/"bin/npm").exist?, "npm must exist"
      assert (HOMEBREW_PREFIX/"bin/npm").executable?, "npm must be executable"
      system "#{HOMEBREW_PREFIX}/bin/npm", "--verbose", "install", "npm@latest"
      system "#{HOMEBREW_PREFIX}/bin/npm", "--verbose", "install", "bignum" unless head?
    end
  end
end
