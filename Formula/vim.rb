class Vim < Formula
  desc "Vi \"workalike\" with many additional features"
  homepage "http://www.vim.org/"
  url "https://github.com/vim/vim/archive/v8.0.0535.tar.gz"
  sha256 "5dcba3fd1392effa1abe077bfdf33d5c7c6e15bb9c24688e9a22e141641b4d9c"
  head "https://github.com/vim/vim.git"

  bottle do
    sha256 "ef6ff6c8c19a7d1068c9bbdae9f51641591729f9c038656c88d6a31f05385c1c" => :sierra
    sha256 "5c6875224970641288cd57e94591c5a0b25cafeaa8b2462f5ff55d6b1ee14aec" => :el_capitan
    sha256 "03f42585af89f3fe81ced30cbe60894efbbbbb3b804a633fb8c264116e6ba807" => :yosemite
  end

  deprecated_option "override-system-vi" => "with-override-system-vi"

  option "with-override-system-vi", "Override system vi"
  option "with-gettext", "Build vim with National Language Support (translated messages, keymaps)"
  option "with-client-server", "Enable client/server mode"

  LANGUAGES_OPTIONAL = %w[lua python3 tcl].freeze
  LANGUAGES_DEFAULT  = %w[perl python ruby].freeze

  if MacOS.version >= :mavericks
    option "with-custom-python", "Build with a custom Python 2 instead of the Homebrew version."
    option "with-custom-ruby", "Build with a custom Ruby instead of the Homebrew version."
    option "with-custom-perl", "Build with a custom Perl instead of the Homebrew version."
  end

  option "with-python3", "Build vim with python3 instead of python[2] support"
  LANGUAGES_OPTIONAL.each do |language|
    option "with-#{language}", "Build vim with #{language} support"
  end
  LANGUAGES_DEFAULT.each do |language|
    option "without-#{language}", "Build vim without #{language} support"
  end

  depends_on :python => :recommended
  depends_on :python3 => :optional
  depends_on :ruby => "1.8" # Can be compiled against 1.8.x or >= 1.9.3-p385.
  depends_on :perl => "5.3"
  depends_on "lua" => :optional
  depends_on "luajit" => :optional
  depends_on :x11 if build.with? "client-server"
  depends_on "gettext" => :optional

  conflicts_with "ex-vi",
    :because => "vim and ex-vi both install bin/ex and bin/view"

  def install
    # https://github.com/Homebrew/homebrew-core/pull/1046
    ENV.delete("SDKROOT")
    ENV["LUA_PREFIX"] = HOMEBREW_PREFIX if build.with?("lua") || build.with?("luajit")

    # vim doesn't require any Python package, unset PYTHONPATH.
    ENV.delete("PYTHONPATH")

    if build.with?("python") && which("python").to_s == "/usr/bin/python" && !MacOS::CLT.installed?
      # break -syslibpath jail
      ln_s "/System/Library/Frameworks", buildpath
      ENV.append "LDFLAGS", "-F#{buildpath}/Frameworks"
    end

    opts = []

    (LANGUAGES_OPTIONAL + LANGUAGES_DEFAULT).each do |language|
      opts << "--enable-#{language}interp" if build.with? language
    end

    if opts.include?("--enable-pythoninterp") && opts.include?("--enable-python3interp")
      # only compile with either python or python3 support, but not both
      # (if vim74 is compiled with +python3/dyn, the Python[3] library lookup segfaults
      # in other words, a command like ":py3 import sys" leads to a SEGV)
      opts -= %w[--enable-pythoninterp]
    end

    opts << "--disable-nls" if build.without? "gettext"
    opts << "--enable-gui=no"

    if build.with? "client-server"
      opts << "--with-x"
    else
      opts << "--without-x"
    end

    if build.with? "lua"
      opts << "--enable-luainterp"
    end

    if build.with? "luajit"
      opts << "--with-luajit"
      opts << "--enable-luainterp"
    end

    # We specify HOMEBREW_PREFIX as the prefix to make vim look in the
    # the right place (HOMEBREW_PREFIX/share/vim/{vimrc,vimfiles}) for
    # system vimscript files. We specify the normal installation prefix
    # when calling "make install".
    # Homebrew will use the first suitable Perl & Ruby in your PATH if you
    # build from source. Please don't attempt to hardcode either.
    system "./configure", "--prefix=#{HOMEBREW_PREFIX}",
                          "--mandir=#{man}",
                          "--enable-multibyte",
                          "--with-tlib=ncurses",
                          "--enable-cscope",
                          "--with-compiledby=Homebrew",
                          *opts
    system "make"
    # Parallel install could miss some symlinks
    # https://github.com/vim/vim/issues/1031
    ENV.deparallelize
    # If stripping the binaries is enabled, vim will segfault with
    # statically-linked interpreters like ruby
    # https://github.com/vim/vim/issues/114
    system "make", "install", "prefix=#{prefix}", "STRIP=#{which "true"}"
    bin.install_symlink "vim" => "vi" if build.with? "override-system-vi"
  end

  test do
    if build.with? "python3"
      (testpath/"commands.vim").write <<-EOS.undent
        :python3 import vim; vim.current.buffer[0] = 'hello python3'
        :wq
      EOS
      system bin/"vim", "-T", "dumb", "-s", "commands.vim", "test.txt"
      assert_equal "hello python3", File.read("test.txt").chomp
    elsif build.with? "python"
      (testpath/"commands.vim").write <<-EOS.undent
        :python import vim; vim.current.buffer[0] = 'hello world'
        :wq
      EOS
      system bin/"vim", "-T", "dumb", "-s", "commands.vim", "test.txt"
      assert_equal "hello world", File.read("test.txt").chomp
    end
    if build.with? "gettext"
      assert_match "+gettext", shell_output("#{bin}/vim --version")
    end
  end
end
