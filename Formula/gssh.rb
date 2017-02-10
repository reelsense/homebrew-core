class Gssh < Formula
  desc "SSH automation tool based on Groovy DSL"
  homepage "https://github.com/int128/groovy-ssh"
  url "https://github.com/int128/groovy-ssh/archive/2.8.0.tar.gz"
  sha256 "d283bb2d42ffad64fc4b6bcaa4c6e0fa3641a672e9b52584149389a6aeed7241"

  bottle do
    cellar :any_skip_relocation
    sha256 "ef87c8277a63c28f90ac45c462571fe9737171d5f0f44a1a22c5cdd8364c924a" => :sierra
    sha256 "26044731fb75bfce1e35486f523d8789fb62ce49b3b1d31f79429faefdd73caa" => :el_capitan
    sha256 "bfb87766d99f8c69b9c9daa0c6656483e570f714ebe81ba2a198b544d23ea842" => :yosemite
  end

  depends_on :java => "1.7+"

  def install
    ENV.java_cache
    ENV["CIRCLE_TAG"] = version
    system "./gradlew", "shadowJar"
    libexec.install "cli/build/libs/gssh.jar"
    bin.write_jar_script libexec/"gssh.jar", "gssh"
  end

  test do
    system bin/"gssh"
  end
end
