class Logstash < Formula
  desc "Tool for managing events and logs"
  homepage "https://www.elastic.co/products/logstash"

  stable do
    url "https://artifacts.elastic.co/downloads/logstash/logstash-5.1.1.tar.gz"
    sha256 "9ce438ec331d3311acc55f22553a3f5a7eaea207b8aa2863164bb2767917de1f"
  end

  head do
    url "https://github.com/elastic/logstash.git"
  end

  bottle :unneeded

  depends_on :java => "1.8+"

  def install
    if build.head?
      # Build the package from source
      system "rake", "artifact:tar"
      # Extract the package to the current directory
      mkdir "tar"
      system "tar", "--strip-components=1", "-xf", Dir["build/logstash-*.tar.gz"].first, "-C", "tar"
      cd "tar"
    end

    inreplace %w[bin/logstash], %r{^\. "\$\(cd `dirname \$SOURCEPATH`\/\.\.; pwd\)\/bin\/logstash\.lib\.sh\"}, ". #{libexec}/bin/logstash.lib.sh"
    inreplace %w[bin/logstash-plugin], %r{^\. "\$\(cd `dirname \$0`\/\.\.; pwd\)\/bin\/logstash\.lib\.sh\"}, ". #{libexec}/bin/logstash.lib.sh"
    inreplace %w[bin/logstash.lib.sh], /^LOGSTASH_HOME=.*$/, "LOGSTASH_HOME=#{libexec}"
    libexec.install Dir["*"]
    bin.install_symlink libexec/"bin/logstash"
    bin.install_symlink libexec/"bin/logstash-plugin"
  end

  def caveats; <<-EOS.undent
    Please read the getting started guide located at:
      https://www.elastic.co/guide/en/logstash/current/getting-started-with-logstash.html
    EOS
  end

  test do
    # workaround https://github.com/elastic/logstash/issues/6378
    mkdir testpath/"config"
    ["jvm.options", "log4j2.properties", "startup.options"].each { |f| cp prefix/"libexec/config/#{f}", testpath/"config" }
    (testpath/"config/logstash.yml").write <<-EOS.undent
      path.queue: #{testpath}/queue
    EOS
    mkdir testpath/"data"
    mkdir testpath/"logs"
    mkdir testpath/"queue"

    output = pipe_output("#{bin}/logstash -e '' --path.data=#{testpath}/data --path.logs=#{testpath}/logs --path.settings=#{testpath}/config --log.level=fatal", "hello world\n")
    assert_match /hello world/, output
  end
end
