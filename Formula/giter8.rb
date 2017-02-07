class Giter8 < Formula
  desc "Generate files and directories from templates in a git repo"
  homepage "https://github.com/foundweekends/giter8"
  url "https://github.com/foundweekends/giter8/archive/v0.7.2.tar.gz"
  sha256 "68d28adb49ac30c30fc177cb97f43aa9b66701dafbd2de77c46d7d771fef9024"

  bottle do
    cellar :any_skip_relocation
    sha256 "087e63f43c6881b0b88b95b0385f4570203bc49b94985ebcd03f5fb9028f0b2b" => :sierra
    sha256 "2da27b3b45953c43fa095e5b015ab19ce911d8bdd284db1ca3f32f515e2f0bed" => :el_capitan
    sha256 "5d8c480329ebcf7e18d33d2eccec83f9af29eec104a98204e827375cfd731b7b" => :yosemite
  end

  depends_on :java => "1.6+"

  resource "conscript" do
    url "https://github.com/foundweekends/conscript.git",
        :tag => "v0.5.1",
        :revision => "0a196fbb0bd551cd7b00196b4032dea2564529ce"
  end

  resource "launcher" do
    url "https://oss.sonatype.org/content/repositories/public/org/scala-sbt/launcher/1.0.0/launcher-1.0.0.jar"
    sha256 "9149549ee09c50bda21ab57990f95aac4dd3919d720367df6198ec7e16480639"
  end

  def install
    conscript_home = libexec/"conscript"
    ENV["CONSCRIPT_HOME"] = conscript_home
    ENV.java_cache

    conscript_home.install resource("launcher")
    launcher = conscript_home/"launcher-#{resource("launcher").version}.jar"
    conscript_home.install_symlink launcher => "sbt-launch.jar"

    resource("conscript").stage do
      cs = conscript_home/"foundweekends/conscript/cs"
      cs.install "src/main/conscript/cs/launchconfig"
      inreplace "setup.sh" do |s|
        s.gsub! /.*wget .*/, ""
        s.gsub! /^ +exec .*/, "exit"
      end
      system "sh", "-x", "setup.sh" # exit code is 1
    end

    system conscript_home/"bin/cs", "foundweekends/giter8/#{version}"
    bin.install_symlink conscript_home/"bin/g8"
  end

  test do
    # sandboxing blocks us from locking libexec/"conscript/boot/sbt.boot.lock"
    cp_r libexec/"conscript", "."
    inreplace %w[conscript/bin/cs conscript/bin/g8
                 conscript/foundweekends/giter8/g8/launchconfig
                 conscript/foundweekends/conscript/cs/launchconfig],
      libexec, testpath
    system testpath/"conscript/bin/g8", "--version"
  end
end
