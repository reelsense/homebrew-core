class Metricbeat < Formula
  desc "Collect metrics from your systems and services."
  homepage "https://www.elastic.co/products/beats/metricbeat"
  url "https://github.com/elastic/beats/archive/v5.6.0.tar.gz"
  sha256 "7ec86da04b97fa7dcddc88250f0f7d2efd06f4ef058cc0097d1d439526b9ed44"

  head "https://github.com/elastic/beats.git"

  bottle do
    sha256 "5903591429538a1681dcb31916ae1cb4465acd3bc0684b6a23ed80919a5c4db1" => :sierra
    sha256 "400393001caf9278d0147d2319fe49619b2b9f23f3d14a48ba13fdc99e103112" => :el_capitan
  end

  depends_on "go" => :build

  def install
    gopath = buildpath/"gopath"
    (gopath/"src/github.com/elastic/beats").install Dir["{*,.git,.gitignore}"]

    ENV["GOPATH"] = gopath

    cd gopath/"src/github.com/elastic/beats/metricbeat" do
      system "make"
      libexec.install "metricbeat"

      (etc/"metricbeat").install "metricbeat.full.yml"
      (etc/"metricbeat").install "metricbeat.yml"
      (etc/"metricbeat").install "metricbeat.template.json"
      (etc/"metricbeat").install "metricbeat.template-es2x.json"
      (etc/"metricbeat").install "metricbeat.template-es6x.json"
    end

    (bin/"metricbeat").write <<-EOS.undent
      #!/bin/sh
      exec "#{libexec}/metricbeat" --path.config "#{etc}/metricbeat" --path.home="#{prefix}" --path.logs="#{var}/log/metricbeat" --path.data="#{opt_prefix}" "$@"
    EOS
  end

  plist_options :manual => "metricbeat"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN"
    "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>Program</key>
        <string>#{opt_bin}/metricbeat</string>
        <key>RunAtLoad</key>
        <true/>
      </dict>
    </plist>
  EOS
  end

  test do
    (testpath/"metricbeat.yml").write <<-EOS.undent
      metricbeat.modules:
      - module: system
        metricsets: ["load"]
        period: 1s
      output.file:
        enabled: true
        path: #{testpath}/data
        filename: metricbeat
    EOS

    (testpath/"logs").mkpath
    (testpath/"data").mkpath

    metricbeat_pid = fork do
      exec bin/"metricbeat", "-c", testpath/"metricbeat.yml",
      "--path.data=#{testpath}/data", "--path.logs=#{testpath}/logs"
    end

    begin
      sleep 2
      assert File.exist? testpath/"data/metricbeat"
    ensure
      Process.kill("TERM", metricbeat_pid)
    end
  end
end
