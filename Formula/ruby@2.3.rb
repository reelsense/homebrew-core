class RubyAT23 < Formula
  desc "Powerful, clean, object-oriented scripting language"
  homepage "https://www.ruby-lang.org/"

  url "https://cache.ruby-lang.org/pub/ruby/2.3/ruby-2.3.4.tar.xz"
  sha256 "341cd9032e9fd17c452ed8562a8d43f7e45bfe05e411d0d7d627751dd82c578c"

  # Reverts an upstream commit which incorrectly tries to install headers
  # into SDKROOT, if defined
  # See https://bugs.ruby-lang.org/issues/11881
  # The issue has been fixed on HEAD as of 1 Jan 2016, but has not been
  # backported to the 2.3 branch yet and patch is still required.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/ba8cc6b88e6b7153ac37739e5a1a6bbbd8f43817/ruby/mkconfig.patch"
    sha256 "929c618f74e89a5e42d899a962d7d2e4af75716523193af42626884eaba1d765"
  end

  bottle do
    sha256 "51a3027c44128bbb9655b9d793a2bd2b14496870bc8ab353ab62b853871d0e35" => :sierra
    sha256 "be70a90b4589fa664ece570627ab5886373eb01db3e57555588b1a81d5a532bb" => :el_capitan
    sha256 "3d0cb6bdbac9062f6c3ee880013e2282f33351d0e6dd7951c3fe43f21c9362d3" => :yosemite
  end

  keg_only :versioned_formula

  option "with-suffix", "Suffix commands with '23'"
  option "with-doc", "Install documentation"
  option "with-tcltk", "Install with Tcl/Tk support"

  depends_on "pkg-config" => :build
  depends_on "readline" => :recommended
  depends_on "gdbm" => :optional
  depends_on "gmp" => :optional
  depends_on "libffi" => :optional
  depends_on "libyaml"
  depends_on "openssl"
  depends_on :x11 if build.with? "tcltk"

  def install
    # otherwise `gem` command breaks
    ENV.delete("SDKROOT")

    args = %W[
      --prefix=#{prefix}
      --enable-shared
      --disable-silent-rules
      --with-sitedir=#{HOMEBREW_PREFIX}/lib/ruby/site_ruby
      --with-vendordir=#{HOMEBREW_PREFIX}/lib/ruby/vendor_ruby
    ]

    args << "--program-suffix=#{program_suffix}" if build.with? "suffix"
    args << "--with-out-ext=tk" if build.without? "tcltk"
    args << "--disable-install-doc" if build.without? "doc"
    args << "--disable-dtrace" unless MacOS::CLT.installed?
    args << "--without-gmp" if build.without? "gmp"

    paths = [
      Formula["libyaml"].opt_prefix,
      Formula["openssl"].opt_prefix,
    ]

    %w[readline gdbm gmp libffi].each do |dep|
      paths << Formula[dep].opt_prefix if build.with? dep
    end

    args << "--with-opt-dir=#{paths.join(":")}"

    system "./configure", *args

    # Ruby has been configured to look in the HOMEBREW_PREFIX for the
    # sitedir and vendordir directories; however we don't actually want to create
    # them during the install.
    #
    # These directories are empty on install; sitedir is used for non-rubygems
    # third party libraries, and vendordir is used for packager-provided libraries.
    inreplace "tool/rbinstall.rb" do |s|
      s.gsub! 'prepare "extension scripts", sitelibdir', ""
      s.gsub! 'prepare "extension scripts", vendorlibdir', ""
      s.gsub! 'prepare "extension objects", sitearchlibdir', ""
      s.gsub! 'prepare "extension objects", vendorarchlibdir', ""
    end

    system "make"
    system "make", "install"

    # A newer version of ruby-mode.el is shipped with Emacs
    elisp.install Dir["misc/*.el"].reject { |f| f == "misc/ruby-mode.el" }
  end

  def post_install
    # Customize rubygems to look/install in the global gem directory
    # instead of in the Cellar, making gems last across reinstalls
    config_file = lib/"ruby/#{abi_version}/rubygems/defaults/operating_system.rb"
    config_file.unlink if config_file.exist?
    config_file.write rubygems_config

    # Create the sitedir and vendordir that were skipped during install
    ruby="#{bin}/ruby#{program_suffix}"
    %w[sitearchdir vendorarchdir].each do |dir|
      mkdir_p `#{ruby} -rrbconfig -e 'print RbConfig::CONFIG["#{dir}"]'`
    end
  end

  def abi_version
    "2.3.0"
  end

  def program_suffix
    build.with?("suffix") ? "23" : ""
  end

  def rubygems_bindir
    "#{HOMEBREW_PREFIX}/bin"
  end

  def rubygems_config; <<-EOS.undent
    module Gem
      class << self
        alias :old_default_dir :default_dir
        alias :old_default_path :default_path
        alias :old_default_bindir :default_bindir
        alias :old_ruby :ruby
      end

      def self.default_dir
        path = [
          "#{HOMEBREW_PREFIX}",
          "lib",
          "ruby",
          "gems",
          "#{abi_version}"
        ]

        @default_dir ||= File.join(*path)
      end

      def self.private_dir
        path = if defined? RUBY_FRAMEWORK_VERSION then
                 [
                   File.dirname(RbConfig::CONFIG['sitedir']),
                   'Gems',
                   RbConfig::CONFIG['ruby_version']
                 ]
               elsif RbConfig::CONFIG['rubylibprefix'] then
                 [
                  RbConfig::CONFIG['rubylibprefix'],
                  'gems',
                  RbConfig::CONFIG['ruby_version']
                 ]
               else
                 [
                   RbConfig::CONFIG['libdir'],
                   ruby_engine,
                   'gems',
                   RbConfig::CONFIG['ruby_version']
                 ]
               end

        @private_dir ||= File.join(*path)
      end

      def self.default_path
        if Gem.user_home && File.exist?(Gem.user_home)
          [user_dir, default_dir, private_dir]
        else
          [default_dir, private_dir]
        end
      end

      def self.default_bindir
        "#{rubygems_bindir}"
      end

      def self.ruby
        "#{opt_bin}/ruby#{program_suffix}"
      end
    end
    EOS
  end

  test do
    hello_text = shell_output("#{bin}/ruby#{program_suffix} -e 'puts :hello'")
    assert_equal "hello\n", hello_text
    ENV["GEM_HOME"] = testpath
    system "#{bin}/gem#{program_suffix}", "install", "json"
  end
end
