class TomcatAT80 < Formula
  desc "Implementation of Java Servlet and JavaServer Pages"
  homepage "https://tomcat.apache.org/"

  stable do
    url "https://www.apache.org/dyn/closer.cgi?path=tomcat/tomcat-8/v8.0.39/bin/apache-tomcat-8.0.39.tar.gz"
    mirror "https://archive.apache.org/dist/tomcat/tomcat-8/v8.0.39/bin/apache-tomcat-8.0.39.tar.gz"
    sha256 "4093aa19f70ebb2749d40fa81486971c1dc7f275da188f1436c62faedaf51e9a"

    depends_on :java => "1.7+"

    resource "fulldocs" do
      url "https://www.apache.org/dyn/closer.cgi?path=/tomcat/tomcat-8/v8.0.39/bin/apache-tomcat-8.0.39-fulldocs.tar.gz"
      mirror "https://archive.apache.org/dist/tomcat/tomcat-8/v8.0.39/bin/apache-tomcat-8.0.39-fulldocs.tar.gz"
      version "8.0.39"
      sha256 "198d67aa67de1a7262e9aa31945a9f53804c37051096c3147c978920ff00a2f6"
    end
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "9ebb7ebde0a3bab24f403056b0436b765cdb080bfef4861e5c5d4e150f302f72" => :sierra
    sha256 "32fe32a8e72c602b18230aa300f59fb62d2b879be026d58c7c5b4f028c8f3627" => :el_capitan
    sha256 "32fe32a8e72c602b18230aa300f59fb62d2b879be026d58c7c5b4f028c8f3627" => :yosemite
  end

  option "with-fulldocs", "Install full documentation locally"

  conflicts_with "tomcat", :because => "Differing versions of same formula"
  conflicts_with "tomcat@6", :because => "Differing versions of same formula"
  conflicts_with "tomcat@7", :because => "Differing versions of same formula"

  def install
    # Remove Windows scripts
    rm_rf Dir["bin/*.bat"]

    # Install files
    prefix.install %w[NOTICE LICENSE RELEASE-NOTES RUNNING.txt]
    libexec.install Dir["*"]
    bin.install_symlink "#{libexec}/bin/catalina.sh" => "catalina"

    (share/"fulldocs").install resource("fulldocs") if build.with? "fulldocs"
  end

  test do
    ENV["CATALINA_BASE"] = testpath
    cp_r Dir["#{libexec}/*"], testpath
    rm Dir["#{libexec}/logs/*"]

    pid = fork do
      exec bin/"catalina", "start"
    end
    sleep 3
    begin
      system bin/"catalina", "stop"
    ensure
      Process.wait pid
    end
    File.exist? testpath/"logs/catalina.out"
  end
end
