class Icecream < Formula
  desc "Distributed compiler with a central scheduler to share build load"
  homepage "https://en.opensuse.org/Icecream"

  stable do
    url "https://github.com/icecc/icecream/archive/1.0.1.tar.gz"
    sha256 "10f85e172c5c435d81e7c05595c5ae9a9ffa83490dded7eefa95f9ad401fb31b"

    # fixes --without-man
    patch do
      url "https://github.com/icecc/icecream/commit/641b039ecaa126fbb3bdfa716ce3060f624bb68e.diff?full_index=1"
      sha256 "2f846e2442b3422511a6d77938d70b74e00f6b90d572cc56f9ab9bfa99c99379"
    end

    # these fix docbook2X detection
    patch do
      url "https://github.com/icecc/icecream/commit/df212c10336b6369ab244d9c888263774c9087dc.diff?full_index=1"
      sha256 "6128f8f9f168efee74976e81ba7f071e522cb9242b62a7ddda22b711359ec080"
    end

    patch do
      url "https://github.com/icecc/icecream/commit/a40bae096bd51f328d6ff299077c5530729b0580.diff?full_index=1"
      sha256 "0f45048093b093ed09bb55f86de8d07d157104b796329c751f98ff240c123071"
    end
  end

  bottle do
    sha256 "85ad1eca8866acbc1666a8054f9e30ccf8acb42c08cd05e6304a34186788dcd4" => :sierra
    sha256 "b7735e14d19d4b8fb4e861fe2b40b19f524ab904c53b954062be9d9a26a2f99c" => :el_capitan
    sha256 "9767c0d31cce91446873f3f4baa8068f73909e575f6a8f81f1ccfa33d17ec2b4" => :yosemite
    sha256 "7dbedeb6418bd830e33818c95bb6339e193f37e664452a1ffc5af514b2778921" => :mavericks
    sha256 "67891ddbf7f15b7e2f66f5e9ef5f12dc719317c2d0503d52aaad23527770affb" => :mountain_lion
  end

  devel do
    url "https://github.com/icecc/icecream/archive/1.1rc1.tar.gz"
    version "1.1rc1"
    sha256 "95bdb66228cc8f5d97a829f1ee4e3f2d32caf064e9614919e8af0f708a13c654"

    depends_on "lzo"
  end

  option "with-docbook2X", "Build with man page"
  option "without-clang-wrappers", "Don't use symlink wrappers for clang/clang++"
  option "with-clang-rewrite-includes", "Use by default Clang's -frewrite-includes option"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "docbook2X" => [:optional, :build]

  def install
    ENV.libstdcxx if ENV.compiler == :clang && build.stable?

    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
    ]
    args << "--without-man" if build.without? "docbook2X"
    args << "--enable-clang-wrappers" if build.with? "clang-wrappers"
    args << "--enable-clang-write-includes" if build.with? "clang-rewrite-includes"

    system "./autogen.sh"
    system "./configure", *args
    system "make", "install"

    (prefix/"org.opensuse.icecc.plist").write iceccd_plist
    (prefix/"org.opensuse.icecc-scheduler.plist").write scheduler_plist
  end

  def caveats; <<-EOS.undent
    To override the toolset with icecc, add to your path:
      #{opt_libexec}/icecc/bin

    To have launchd start the icecc daemon at login:
      cp #{opt_prefix}/org.opensuse.icecc.plist ~/Library/LaunchAgents/
      launchctl load -w ~/Library/LaunchAgents/org.opensuse.icecc.plist
    EOS
  end

  def iceccd_plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
        <key>Label</key>
        <string>Icecc Daemon</string>
        <key>ProgramArguments</key>
        <array>
        <string>#{sbin}/iceccd</string>
        <string>-d</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
    </dict>
    </plist>
    EOS
  end

  def scheduler_plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
        <key>Label</key>
        <string>Icecc Scheduler</string>
        <key>ProgramArguments</key>
        <array>
        <string>#{sbin}/icecc-scheduler</string>
        <string>-d</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
    </dict>
    </plist>
    EOS
  end

  test do
    (testpath/"hello-c.c").write <<-EOS.undent
      #include <stdio.h>
      int main()
      {
        puts("Hello, world!");
        return 0;
      }
    EOS
    system opt_libexec/"icecc/bin/gcc", "-o", "hello-c", "hello-c.c"
    assert_equal "Hello, world!\n", shell_output("./hello-c")

    (testpath/"hello-cc.cc").write <<-EOS.undent
      #include <iostream>
      int main()
      {
        std::cout << "Hello, world!" << std::endl;
        return 0;
      }
    EOS
    system opt_libexec/"icecc/bin/g++", "-o", "hello-cc", "hello-cc.cc"
    assert_equal "Hello, world!\n", shell_output("./hello-cc")

    if build.with? "clang-wrappers"
      (testpath/"hello-clang.c").write <<-EOS.undent
        #include <stdio.h>
        int main()
        {
          puts("Hello, world!");
          return 0;
        }
      EOS
      system opt_libexec/"icecc/bin/clang", "-o", "hello-clang", "hello-clang.c"
      assert_equal "Hello, world!\n", shell_output("./hello-clang")

      (testpath/"hello-cclang.cc").write <<-EOS.undent
        #include <iostream>
        int main()
        {
          std::cout << "Hello, world!" << std::endl;
          return 0;
        }
      EOS
      system opt_libexec/"icecc/bin/clang++", "-o", "hello-cclang", "hello-cclang.cc"
      assert_equal "Hello, world!\n", shell_output("./hello-cclang")
    end
  end
end
