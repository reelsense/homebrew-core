require "language/node"

class KibanaAT41 < Formula
  desc "Analytics and search dashboard for Elasticsearch"
  homepage "https://www.elastic.co/products/kibana"
  url "https://github.com/elastic/kibana.git", :tag => "v4.1.11", :revision => "c55c5d9acf510bed020a4fdc1c4ca8c81c7b7a1b"
  head "https://github.com/elastic/kibana.git"

  bottle do
    sha256 "d81ea2796186dd5e9c72dea66e999e146303dde2142530616d41830b9b5a40a1" => :sierra
    sha256 "9b5eca0a33f7c527bd99df0231ebf4411a379cd7fc6530ed006281fa31dcc6e4" => :el_capitan
    sha256 "9cd201b9528383802ea1aac3881782d414638f9fe8b8e25b1d53e542a2f80d05" => :yosemite
  end

  keg_only :versioned_formula

  resource "node" do
    url "https://nodejs.org/dist/v4.4.7/node-v4.4.7.tar.xz"
    sha256 "1ef900b9cb3ffb617c433a3247a9d67ff36c9455cbc9c34175bee24bdbfdf731"
  end

  def install
    resource("node").stage buildpath/"node"
    cd buildpath/"node" do
      system "./configure", "--prefix=#{libexec}/node"
      system "make", "install"
    end

    # do not download binary installs of Node.js
    inreplace buildpath/"tasks/build.js", /('download_node_binaries',)/, "// \\1"

    # do not build packages for other platforms
    if MacOS.prefer_64_bit?
      platform = "darwin-x64"
    else
      raise "Installing Kibana via Homebrew is only supported on macOS x86_64"
    end
    inreplace buildpath/"Gruntfile.js", /^(\s+)platforms: .*/, "\\1platforms: [ '#{platform}' ],"

    # do not build zip packages
    inreplace buildpath/"tasks/config/compress.js", /(build_zip: .*)/, "// \\1"

    ENV.prepend_path "PATH", prefix/"libexec/node/bin"
    Pathname.new("#{ENV["HOME"]}/.npmrc").write Language::Node.npm_cache_config
    system "npm", "install", "--verbose"
    system "node_modules/.bin/grunt", "build"

    mkdir "tar" do
      system "tar", "--strip-components", "1", "-xf", Dir[buildpath/"target/kibana-*-#{platform}.tar.gz"].first

      rm_f Dir["bin/*.bat"]
      prefix.install "bin", "config", "plugins", "src"
    end

    inreplace "#{bin}/kibana", %r{/node/bin/node}, "/libexec/node/bin/node"

    cd prefix do
      inreplace "config/kibana.yml", %r{/var\/run\/kibana.pid}, var/"run/kibana.pid"
      (etc/"kibana").install Dir["config/*"]
      rm_rf "config"

      (var/"kibana/plugins").install Dir["plugins/*"]
      rm_rf "plugins"
    end
  end

  def post_install
    ln_s etc/"kibana", prefix/"config"
    ln_s var/"kibana/plugins", prefix/"plugins"
  end

  def caveats; <<-EOS.undent
    Plugins: #{var}/kibana/plugins/
    Config: #{etc}/kibana/
    EOS
  end

  plist_options :manual => "kibana"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN"
    "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>Program</key>
        <string>#{opt_bin}/kibana</string>
        <key>RunAtLoad</key>
        <true/>
      </dict>
    </plist>
  EOS
  end

  test do
    ENV["BABEL_CACHE_PATH"] = testpath/".babelcache.json"
    assert_match /#{version}/, shell_output("#{bin}/kibana -V")
  end
end
