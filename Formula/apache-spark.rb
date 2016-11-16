class ApacheSpark < Formula
  desc "Engine for large-scale data processing"
  homepage "https://spark.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=spark/spark-2.0.2/spark-2.0.2-bin-hadoop2.7.tgz"
  version "2.0.2"
  sha256 "e6349dd38ded84831e3ff7d391ae7f2525c359fb452b0fc32ee2ab637673552a"
  head "https://github.com/apache/spark.git"

  bottle :unneeded

  def install
    # Rename beeline to distinguish it from hive's beeline
    mv "bin/beeline", "bin/spark-beeline"

    rm_f Dir["bin/*.cmd"]
    libexec.install Dir["*"]
    bin.write_exec_script Dir["#{libexec}/bin/*"]
  end

  test do
    system "#{bin}/spark-shell <<<'sc.parallelize(1 to 1000).count()'"
  end
end
