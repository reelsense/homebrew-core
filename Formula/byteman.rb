class Byteman < Formula
  desc "Java bytecode manipulation tool for testing, monitoring and tracing."
  homepage "https://byteman.jboss.org/"
  url "https://downloads.jboss.org/byteman/3.0.5/byteman-download-3.0.5-bin.zip"
  sha256 "c7b90b63346d4a0f648c55e12c21110fb173fb9ae8471727fd44906591fa8c26"

  devel do
    url "https://downloads.jboss.org/byteman/4.0.0-BETA0/byteman-download-4.0.0-BETA0-bin.zip"
    sha256 "345b10b207e7213e96a124b05b52b71fb932d1668733cbd7e0b4ec4f497bb5a8"
    version "4.0.0-BETA0"
  end

  bottle :unneeded
  depends_on :java => "1.6+"

  def install
    rm_rf Dir["bin/*.bat"]
    doc.install Dir["docs/*"], "README"
    libexec.install ["bin", "lib", "contrib"]
    pkgshare.install ["sample"]

    env = Language::Java.java_home_env("1.6+").merge(:BYTEMAN_HOME => libexec)
    Pathname.glob("#{libexec}/bin/*") do |file|
      target = bin/File.basename(file, File.extname(file))
      # Drop the .sh from the scripts
      target.write_env_script(libexec/"bin/#{File.basename(file)}", env)
    end
  end

  test do
    (testpath/"src/main/java/BytemanHello.java").write <<-EOS.undent
      class BytemanHello {
        public static void main(String... args) {
          System.out.println("Hello, Brew!");
        }
      }
    EOS

    (testpath/"brew.btm").write <<-EOS.undent
      RULE trace main entry
      CLASS BytemanHello
      METHOD main
      AT ENTRY
      IF true
      DO traceln("Entering main")
      ENDRULE

      RULE trace main exit
      CLASS BytemanHello
      METHOD main
      AT EXIT
      IF true
      DO traceln("Exiting main")
      ENDRULE
    EOS
    # Compile example
    system "javac", "src/main/java/BytemanHello.java"
    # Expected successful output when Byteman runs example
    expected = <<-EOS.undent
    Entering main
    Hello, Brew!
    Exiting main
    EOS
    actual = shell_output("#{bin}/bmjava -l brew.btm -cp src/main/java BytemanHello")
    assert_equal(expected, actual)
  end
end
