class DnscryptProxy < Formula
  desc "Secure communications between a client and a DNS resolver"
  homepage "https://dnscrypt.org"
  url "https://github.com/jedisct1/dnscrypt-proxy/archive/1.9.1.tar.gz"
  sha256 "1797a4f3c4bacbe872ce7b9f9b3a88f09b9e41776429a37555581f0e832496de"
  head "https://github.com/jedisct1/dnscrypt-proxy.git"

  bottle do
    sha256 "8ba7499cf515996462c3826bc475e3834f3f2bb032fa385c667a4ef844e2eb81" => :sierra
    sha256 "14d57e687899746ede2dad8370484d8ed19e338a65a171c5c0008d74df92bb8a" => :el_capitan
    sha256 "6a88a97fe3b416865c8e0d17042f12247a0dc25f4650760a077efb0735198f78" => :yosemite
  end

  option "with-plugins", "Support plugins and install example plugins."

  deprecated_option "plugins" => "with-plugins"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "libtool" => :run
  depends_on "libsodium"
  depends_on "minisign" => :recommended
  depends_on "ldns" => :recommended

  def install
    system "./autogen.sh"

    args = %W[--disable-dependency-tracking --prefix=#{prefix}]

    if build.with? "plugins"
      args << "--enable-plugins"
      args << "--enable-relaxed-plugins-permissions"
      args << "--enable-plugins-root"
    end

    system "./configure", *args
    system "make", "install"
    pkgshare.install Dir["contrib/*"] - Dir["contrib/Makefile*"]

    if build.with? "minisign"
      (bin/"dnscrypt-update-resolvers").write <<-EOS.undent
        #!/bin/sh
        RESOLVERS_UPDATES_BASE_URL=https://download.dnscrypt.org/dnscrypt-proxy
        RESOLVERS_LIST_BASE_DIR=#{pkgshare}
        RESOLVERS_LIST_PUBLIC_KEY="RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3"

        curl -L --max-redirs 5 -4 -m 30 --connect-timeout 30 -s \
          "${RESOLVERS_UPDATES_BASE_URL}/dnscrypt-resolvers.csv" > \
          "${RESOLVERS_LIST_BASE_DIR}/dnscrypt-resolvers.csv.tmp" && \
        curl -L --max-redirs 5 -4 -m 30 --connect-timeout 30 -s \
          "${RESOLVERS_UPDATES_BASE_URL}/dnscrypt-resolvers.csv.minisig" > \
          "${RESOLVERS_LIST_BASE_DIR}/dnscrypt-resolvers.csv.minisig" && \
        minisign -Vm ${RESOLVERS_LIST_BASE_DIR}/dnscrypt-resolvers.csv.tmp \
          -x "${RESOLVERS_LIST_BASE_DIR}/dnscrypt-resolvers.csv.minisig" \
          -P "$RESOLVERS_LIST_PUBLIC_KEY" -q && \
        mv -f ${RESOLVERS_LIST_BASE_DIR}/dnscrypt-resolvers.csv.tmp \
          ${RESOLVERS_LIST_BASE_DIR}/dnscrypt-resolvers.csv
      EOS
      chmod 0775, bin/"dnscrypt-update-resolvers"
    end
  end

  def post_install
    return if build.without? "minisign"

    system bin/"dnscrypt-update-resolvers"
  end

  def caveats
    s = <<-EOS.undent
      After starting dnscrypt-proxy, you will need to point your
      local DNS server to 127.0.0.1. You can do this by going to
      System Preferences > "Network" and clicking the "Advanced..."
      button for your interface. You will see a "DNS" tab where you
      can click "+" and enter 127.0.0.1 in the "DNS Servers" section.

      By default, dnscrypt-proxy runs on localhost (127.0.0.1), port 53,
      and under the "nobody" user using the dnscrypt.eu-dk DNSCrypt-enabled
      resolver. If you would like to change these settings, you will have to edit
      the plist file (e.g., --resolver-address, --provider-name, --provider-key, etc.)

      To check that dnscrypt-proxy is working correctly, open Terminal and enter the
      following command. Replace en1 with whatever network interface you're using:

          sudo tcpdump -i en1 -vvv 'port 443'

      You should see a line in the result that looks like this:

          resolver2.dnscrypt.eu.https
    EOS

    if build.with? "minisign"
      s += <<-EOS.undent

        If at some point the resolver file gets outdated, it can be updated to the
        latest version by running: #{opt_bin}/dnscrypt-update-resolvers
      EOS
    end

    s
  end

  plist_options :startup => true

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-/Apple/DTD PLIST 1.0/EN" "http:/www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>KeepAlive</key>
        <true/>
        <key>RunAtLoad</key>
        <true/>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_sbin}/dnscrypt-proxy</string>
          <string>--ephemeral-keys</string>
          <string>--resolvers-list=#{opt_pkgshare}/dnscrypt-resolvers.csv</string>
          <string>--resolver-name=dnscrypt.eu-dk</string>
          <string>--user=nobody</string>
        </array>
        <key>UserName</key>
        <string>root</string>
        <key>StandardErrorPath</key>
        <string>/dev/null</string>
        <key>StandardOutPath</key>
        <string>/dev/null</string>
      </dict>
    </plist>
    EOS
  end

  test do
    system "#{sbin}/dnscrypt-proxy", "--version"
  end
end
