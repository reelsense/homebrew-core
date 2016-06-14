class Apktool < Formula
  desc "Tool for reverse engineering 3rd party, closed, binary Android apps"
  homepage "https://github.com/iBotPeaches/Apktool"
  url "https://bitbucket.org/iBotPeaches/apktool/downloads/apktool_2.1.1.jar", :using => :nounzip
  sha256 "48c2a23cae1f1e778f3c9d79b804823e6c175f7f243064cd61a3ea0f7b71c292"

  bottle :unneeded

  resource "sample.apk" do
    url "https://github.com/downloads/stephanenicolas/RoboDemo/robodemo-sample-1.0.1.apk", :using => :nounzip
    sha256 "bf3ec04631339538c8edb97ebbd5262c3962c5873a2df9022385156c775eb81f"
  end

  def install
    libexec.install "apktool_#{version}.jar"
    bin.write_jar_script libexec/"apktool_#{version}.jar", "apktool"
  end

  test do
    resource("sample.apk").stage do
      system "#{bin}/apktool", "d", "robodemo-sample-1.0.1.apk"
      system "#{bin}/apktool", "b", "robodemo-sample-1.0.1"
    end
  end
end
