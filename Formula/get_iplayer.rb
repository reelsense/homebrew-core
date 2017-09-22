class GetIplayer < Formula
  desc "Utility for downloading TV and radio programmes from BBC iPlayer"
  homepage "https://github.com/get-iplayer/get_iplayer"
  url "https://github.com/get-iplayer/get_iplayer/archive/v3.02.tar.gz"
  sha256 "45f38f25ea03d089523c0a4ecdc6905f1980e32e0df3bc922bad1bb282894675"
  head "https://github.com/get-iplayer/get_iplayer.git", :branch => "develop"

  bottle do
    cellar :any_skip_relocation
    sha256 "1b0a08bfc130b21c45356248b11a66d6a6dc2b6c1f5739a387f3b69d073b2220" => :high_sierra
    sha256 "25b0b4c1deb8ee39f528fc81ca1c436d6ee16b9b5f4764a9eff8ecffff22fd22" => :sierra
    sha256 "25b0b4c1deb8ee39f528fc81ca1c436d6ee16b9b5f4764a9eff8ecffff22fd22" => :el_capitan
    sha256 "9430c06cc056ce2f7b474bed1e199e4d3ddaa648e2ce611dcf2828be24cb89ed" => :yosemite
  end

  depends_on "atomicparsley" => :recommended
  depends_on "ffmpeg" => :recommended

  depends_on :macos => :yosemite

  resource "IO::Socket::IP" do
    url "https://cpan.metacpan.org/authors/id/P/PE/PEVANS/IO-Socket-IP-0.39.tar.gz"
    sha256 "11950da7636cb786efd3bfb5891da4c820975276bce43175214391e5c32b7b96"
  end

  resource "Mojolicious" do
    url "https://cpan.metacpan.org/authors/id/S/SR/SRI/Mojolicious-7.43.tar.gz"
    sha256 "ca177da7b0c1e2a31a1880c4a06afbbd1ada1da57146bfa030b7912a3d608b5e"
  end

  def install
    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"

    resources.each do |r|
      r.stage do
        system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
        system "make", "install"
      end
    end

    inreplace ["get_iplayer", "get_iplayer.cgi"] do |s|
      s.gsub!(/^(my \$version_text);/i, "\\1 = \"#{pkg_version}-homebrew\";")
      s.gsub! "#!/usr/bin/env perl", "#!/usr/bin/perl"
    end

    bin.install "get_iplayer", "get_iplayer.cgi"
    bin.env_script_all_files(libexec/"bin", :PERL5LIB => ENV["PERL5LIB"])
    man1.install "get_iplayer.1"
  end

  test do
    output = shell_output("\"#{bin}/get_iplayer\" --refresh --refresh-include=\"BBC None\" --quiet dontshowanymatches 2>&1")
    assert_match "get_iplayer #{pkg_version}-homebrew", output, "Unexpected version"
    assert_match "INFO: 0 matching programmes", output, "Unexpected output"
    assert_match "INFO: Using concurrent indexing", output,
                         "Mojolicious not found"
  end
end
