class Ice < Formula
  desc "Comprehensive RPC framework"
  homepage "https://zeroc.com"
  url "https://github.com/zeroc-ice/ice/archive/v3.6.3.tar.gz"
  sha256 "82ff74e6d24d9fa396dbb4d9697dc183b17bc9c3f6f076fecdc05632be80a2dc"
  revision 1

  bottle do
    sha256 "f77f68326d23a4fe732f7ddc771e766959902ebbe490a1712d21a9b4da666d7e" => :sierra
    sha256 "a766b8562df95b2215cdc349027eb271711a52d22d8433f12d01a945fc79067b" => :el_capitan
    sha256 "0731860bd7cebc7585dba29ea8c90497c198257adb69bddf9333798bb1d219c4" => :yosemite
  end

  option "with-java", "Build Ice for Java and the IceGrid Admin app"

  depends_on "mcpp"
  depends_on :java => ["1.7+", :optional]
  depends_on :macos => :mavericks

  resource "berkeley-db" do
    url "https://zeroc.com/download/homebrew/db-5.3.28.NC.brew.tar.gz"
    sha256 "8ac3014578ff9c80a823a7a8464a377281db0e12f7831f72cef1fd36cd506b94"
  end

  def install
    resource("berkeley-db").stage do
      # BerkeleyDB dislikes parallel builds
      ENV.deparallelize
      args = %W[
        --disable-debug
        --prefix=#{libexec}
        --mandir=#{libexec}/man
        --enable-cxx
      ]

      if build.with? "java"
        args << "--enable-java"

        # @externl from ZeroC submitted this patch to Oracle through an internal ticket system
        inreplace "dist/Makefile.in", "@JAVACFLAGS@", "@JAVACFLAGS@ -source 1.7 -target 1.7"
      end

      # BerkeleyDB requires you to build everything from the build_unix subdirectory
      cd "build_unix" do
        system "../dist/configure", *args
        system "make", "install"
      end
    end

    inreplace "cpp/src/slice2js/Makefile", /install:/, "dontinstall:"

    # Unset ICE_HOME as it interferes with the build
    ENV.delete("ICE_HOME")
    ENV.delete("USE_BIN_DIST")
    ENV.delete("CPPFLAGS")
    ENV.O2

    # Ensure Gradle uses a writable directory even in sandbox mode
    ENV["GRADLE_USER_HOME"] = buildpath/".gradle"

    args = %W[
      prefix=#{prefix}
      embedded_runpath_prefix=#{prefix}
      USR_DIR_INSTALL=yes
      SLICE_DIR_SYMLINK=yes
      OPTIMIZE=yes
      DB_HOME=#{libexec}
      MCPP_HOME=#{Formula["mcpp"].opt_prefix}
    ]

    cd "cpp" do
      system "make", "install", *args
    end

    cd "objective-c" do
      system "make", "install", *args
    end

    if build.with? "java"
      cd "java" do
        system "make", "install", *args
      end
    end

    cd "php" do
      args << "install_phpdir=#{share}/php"
      args << "install_libdir=#{lib}/php/extensions"
      system "make", "install", *args
    end
  end

  test do
    (testpath/"Hello.ice").write <<-EOS.undent
      module Test {
        interface Hello {
          void sayHello();
        };
      };
    EOS
    (testpath/"Test.cpp").write <<-EOS.undent
      #include <Ice/Ice.h>
      #include <Hello.h>

      class HelloI : public Test::Hello {
      public:
        virtual void sayHello(const Ice::Current&) {}
      };

      int main(int argc, char* argv[]) {
        Ice::CommunicatorPtr communicator;
        communicator = Ice::initialize(argc, argv);
        Ice::ObjectAdapterPtr adapter =
            communicator->createObjectAdapterWithEndpoints("Hello", "default -h localhost -p 10000");
        adapter->add(new HelloI, communicator->stringToIdentity("hello"));
        adapter->activate();
        communicator->destroy();
        return 0;
      }
    EOS
    system "#{bin}/slice2cpp", "Hello.ice"
    system "xcrun", "clang++", "-c", "-I#{include}", "-I.", "Hello.cpp"
    system "xcrun", "clang++", "-c", "-I#{include}", "-I.", "Test.cpp"
    system "xcrun", "clang++", "-L#{lib}", "-o", "test", "Test.o", "Hello.o", "-lIce", "-lIceUtil"
    system "./test", "--Ice.InitPlugins=0"
    system "/usr/bin/php", "-d", "extension_dir=#{lib}/php/extensions",
                           "-d", "extension=IcePHP.dy",
                           "-r", "extension_loaded('ice') ? exit(0) : exit(1);"
  end
end
