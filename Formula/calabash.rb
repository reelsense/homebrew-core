class Calabash < Formula
  desc "XProc (XML Pipeline Language) implementation"
  homepage "http://xmlcalabash.com"
  url "https://github.com/ndw/xmlcalabash1/releases/download/1.1.13-97/xmlcalabash-1.1.13-97.zip"
  sha256 "ca1cb14857b6216daf6773ab46e5ae6380a9d0035bd1ea652f464e6e335b53e2"

  bottle :unneeded

  depends_on "saxon"

  def install
    libexec.install Dir["*"]
    bin.write_jar_script libexec/"xmlcalabash-#{version}.jar", "calabash", "-Xmx1024m"
  end

  test do
    # This small XML pipeline (*.xpl) that comes with Calabash
    # is basically its equivalent "Hello World" program.
    system "#{bin}/calabash", "#{libexec}/xpl/pipe.xpl"
  end
end
