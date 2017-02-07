class DnscryptProxy < Formula
  desc "Secure communications between a client and a DNS resolver"
  homepage "https://dnscrypt.org"
  url "https://github.com/jedisct1/dnscrypt-proxy/archive/1.9.4.tar.gz"
  sha256 "a79d5da0133344d38f8b3d3355c16269f11c15fbeedd0521e1a657b00ac503bb"
  revision 1
  head "https://github.com/jedisct1/dnscrypt-proxy.git"

  bottle do
    sha256 "14de34e98b96ef029d98202ca0422ee9e35345bcea3881e0d990c6d193295506" => :sierra
    sha256 "dd17ce5cf3bd581f94e42e12ecde0bf6f80510b5443452d5099b392be9b10b35" => :el_capitan
    sha256 "7de091af5d6b8d2ebe22fba6be333ac6431bbeb0ab545747def1f8923e8a26d1" => :yosemite
  end

  option "with-plugins", "Support plugins and install example plugins."

  deprecated_option "plugins" => "with-plugins"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "libtool" => :run
  depends_on "libsodium"
  depends_on "minisign" => :recommended if MacOS.version >= :el_capitan
  depends_on "ldns" => :recommended

  def install
    # Modify hard-coded path to resolver list
    inreplace "dnscrypt-proxy.conf",
      "# ResolversList /usr/local/share/dnscrypt-proxy/dnscrypt-resolvers.csv",
      "ResolversList #{opt_pkgshare}/dnscrypt-resolvers.csv"

    # Run as unprivileged user
    inreplace "dnscrypt-proxy.conf", "# User _dnscrypt-proxy", "User nobody"

    system "./autogen.sh"

    args = %W[--disable-dependency-tracking --prefix=#{prefix} --sysconfdir=#{etc}]

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
      and under the "nobody" user using a random resolver. If you would like to
      change these settings, you will have to edit the configuration file:
      #{etc}/dnscrypt-proxy.conf (e.g., ResolverName, etc.)

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
          <string>#{etc}/dnscrypt-proxy.conf</string>
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
