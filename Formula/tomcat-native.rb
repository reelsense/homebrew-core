class TomcatNative < Formula
  desc "Lets Tomcat use some native resources for performance"
  homepage "https://tomcat.apache.org/native-doc/"
  url "https://www.apache.org/dyn/closer.cgi?path=tomcat/tomcat-connectors/native/1.2.8/source/tomcat-native-1.2.8-src.tar.gz"
  mirror "https://archive.apache.org/dist/tomcat/tomcat-connectors/native/1.2.8/source/tomcat-native-1.2.8-src.tar.gz"
  sha256 "408ece0b027c8967b3aa85533c5fca642827e235b1857d28df918a4eab861d30"

  bottle do
    cellar :any
    sha256 "45c35c0d029a0ef7fbe1b02877f44c1db38f4467300e14cd79606df1e872a7d7" => :el_capitan
    sha256 "eb6dc9cf198cfa54462e9934b73df7b167a49355ba65390dd8dcb4d125dc7191" => :yosemite
    sha256 "a874e4a8121681fe53dda34028946c60274f1f60021b7defd2daf6dfa353b7f0" => :mavericks
  end

  option "with-apr", "Include APR support via Homebrew"

  depends_on "libtool" => :build
  depends_on "tomcat" => :recommended
  depends_on :java => "1.7+"
  depends_on "openssl"
  depends_on "apr" => :optional

  def install
    cd "native" do
      if build.with? "apr"
        apr_path = Formula["apr"].opt_prefix
      else
        apr_path = "#{MacOS.sdk_path}/usr"
      end
      system "./configure", "--prefix=#{prefix}",
                            "--with-apr=#{apr_path}",
                            "--with-java-home=#{ENV["JAVA_HOME"]}",
                            "--with-ssl=#{Formula["openssl"].opt_prefix}"

      # fixes occasional compiling issue: glibtool: compile: specify a tag with `--tag'
      args = ["LIBTOOL=glibtool --tag=CC"]
      # fixes a broken link in mountain lion's apr-1-config (it should be /XcodeDefault.xctoolchain/):
      # usr/local/opt/libtool/bin/glibtool: line 1125: /Applications/Xcode.app/Contents/Developer/Toolchains/OSX10.8.xctoolchain/usr/bin/cc: No such file or directory
      args << "CC=#{ENV.cc}" if MacOS.version >= :mountain_lion
      system "make", *args
      system "make", "install"
    end
  end

  def caveats; <<-EOS.undent
    In order for tomcat's APR lifecycle listener to find this library, you'll
    need to add it to java.library.path. This can be done by adding this line
    to $CATALINA_HOME/bin/setenv.sh

      CATALINA_OPTS=\"$CATALINA_OPTS -Djava.library.path=#{lib}\"

    If $CATALINA_HOME/bin/setenv.sh doesn't exist, create it and make it executable.
    EOS
  end
end
