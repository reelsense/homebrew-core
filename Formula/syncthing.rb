class Syncthing < Formula
  desc "Open source continuous file synchronization application"
  homepage "https://syncthing.net/"
  head "https://github.com/syncthing/syncthing.git"

  stable do
    url "https://github.com/syncthing/syncthing.git",
        :tag => "v0.14.33",
        :revision => "d475ad7ce1c994358888c2fed250427ed0ef0243"

    # Upstream fix for a sandbox violation triggered by the noupgrade option
    # Reported 25 Jul 2017 https://github.com/syncthing/syncthing/issues/4272
    patch do
      url "https://github.com/syncthing/syncthing/commit/414c58174.patch?full_index=1"
      sha256 "07419dc8b75766b2e4788d8eee1c80ed4238e262d1474813a6b6586494bf1aef"
    end
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "f26072e2f8cfc96fbcc0a94eddc87207698706843a032212a573bb885b3b6646" => :sierra
    sha256 "5449ede37f226b348e7689f065997cc89237d9c65574a931a365165670312b5c" => :el_capitan
    sha256 "db321b9ccdb5e7e0d023bbf32aeb8c6124706d6ac4e2ca2eeff450833a51be8f" => :yosemite
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/syncthing/syncthing").install buildpath.children
    ENV.append_path "PATH", buildpath/"bin"
    cd buildpath/"src/github.com/syncthing/syncthing" do
      system "./build.sh", "noupgrade"
      bin.install "syncthing"
      man1.install Dir["man/*.1"]
      man5.install Dir["man/*.5"]
      man7.install Dir["man/*.7"]
      prefix.install_metafiles
    end
  end

  plist_options :manual => "syncthing"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_bin}/syncthing</string>
          <string>-no-browser</string>
          <string>-no-restart</string>
        </array>
        <key>KeepAlive</key>
        <dict>
          <key>Crashed</key>
          <true/>
          <key>SuccessfulExit</key>
          <false/>
        </dict>
        <key>ProcessType</key>
        <string>Background</string>
        <key>StandardErrorPath</key>
        <string>#{var}/log/syncthing.log</string>
        <key>StandardOutPath</key>
        <string>#{var}/log/syncthing.log</string>
      </dict>
    </plist>
    EOS
  end

  test do
    system bin/"syncthing", "-generate", "./"
  end
end
