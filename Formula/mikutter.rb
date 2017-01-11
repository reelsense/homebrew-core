class Mikutter < Formula
  desc "Extensible Twitter client."
  homepage "http://mikutter.hachune.net"
  url "http://mikutter.hachune.net/bin/mikutter.3.5.1.tar.gz"
  sha256 "082ce9795208e7ca5f218178091123c56b735b2c0d59b742c17998d71a321737"
  head "git://toshia.dip.jp/mikutter.git", :branch => "develop"

  bottle do
    sha256 "41fda605f06e835ce7a50b1664ffac656c4173a3fc002381be25ed3a7708161f" => :sierra
    sha256 "062ec0357da82068721fa9a41f5df560541e626cbcd3b919c8d52706e72f294e" => :el_capitan
    sha256 "c062a865853181d9d92714c5c83ea2693ddf3d020113b3a2d48a6b5c8e5140d7" => :yosemite
  end

  depends_on "gtk+"
  depends_on "terminal-notifier" => :recommended
  depends_on :ruby => "2.1"

  resource "addressable" do
    url "https://rubygems.org/gems/addressable-2.5.0.gem"
    sha256 "bc5bf921b39640675fbb3484cdb45e4241b4c88d8d5a7d85a3985424ad02b9c8"
  end

  resource "atk" do
    url "https://rubygems.org/gems/atk-3.1.0.gem"
    sha256 "6a6f7e68bc7c205abc4a35156d24eb4d248f4855d4775a5295e2a6bdd9f61c5f"
  end

  resource "cairo" do
    url "https://rubygems.org/gems/cairo-1.15.3.gem"
    sha256 "16cf6fdce8671b90a22079cb5734f5c43f1f7e315a69fe276c7080ff41f64e5a"
  end

  resource "crack" do
    url "https://rubygems.org/gems/crack-0.4.3.gem"
    sha256 "5318ba8cd9cf7e0b5feb38948048503ba4b1fdc1b6ff30a39f0a00feb6036b29"
  end

  resource "delayer" do
    url "https://rubygems.org/gems/delayer-0.0.2.gem"
    sha256 "39ece17be3e4528d562a88aef7cb25143ef4ce77df2925a7534f8a163af1db94"
  end

  resource "delayer-deferred" do
    url "https://rubygems.org/gems/delayer-deferred-1.0.4.gem"
    sha256 "6bef17fec576f81fb74db5b6d1b883abec1824976120ccf99f413f34e385e2e6"
  end

  resource "gdk_pixbuf2" do
    url "https://rubygems.org/gems/gdk_pixbuf2-3.1.0.gem"
    sha256 "6743e0ab8d50f74cff1f2f8098e4ae44ff78e2e560631fbad247d135e3e3fb21"
  end

  resource "gettext" do
    url "https://rubygems.org/gems/gettext-3.2.2.gem"
    sha256 "9d250bb79273efb4a268977f219d2daca05cdc7473eff40288b8ab8ddd0f51b4"
  end

  resource "glib2" do
    url "https://rubygems.org/gems/glib2-3.1.0.gem"
    sha256 "0bad2e823df07fcc9f3f2490ad3f1b1c157852f48564742f3a758d50085009fd"
  end

  resource "gtk2" do
    url "https://rubygems.org/gems/gtk2-3.1.0.gem"
    sha256 "2b26efdf8d63b6dce85e5c11798c439a2e238f87bbc372a331bb0c879badc818"
  end

  resource "hashdiff" do
    url "https://rubygems.org/gems/hashdiff-0.3.1.gem"
    sha256 "fef28aadc110e1770488c6c777f16ec729244ed4e7cdd027013bf2381e09b71e"
  end

  resource "httpclient" do
    url "https://rubygems.org/gems/httpclient-2.8.3.gem"
    sha256 "2951e4991214464c3e92107e46438527d23048e634f3aee91c719e0bdfaebda6"
  end

  resource "instance_storage" do
    url "https://rubygems.org/gems/instance_storage-1.0.0.gem"
    sha256 "f41e64da2fe4f5f7d6c8cf9809ef898e660870f39d4e5569c293b584a12bce22"
  end

  resource "json_pure" do
    url "https://rubygems.org/gems/json_pure-2.0.2.gem"
    sha256 "def9c4d3da29b3d36033d4b019b045520b1ee4968161630f4b422c7e18b6c83b"
  end

  resource "locale" do
    url "https://rubygems.org/gems/locale-2.1.2.gem"
    sha256 "1db4a6b5f21fcd64f397d61bf2af69840dc11b3176d1fa6d75a0e749f04a9aea"
  end

  resource "memoist" do
    url "https://rubygems.org/gems/memoist-0.15.0.gem"
    sha256 "b838329d7fe7e067e0d0717828db529126f44b8c0c527c884d162ebb4ecba379"
  end

  resource "metaclass" do
    url "https://rubygems.org/gems/metaclass-0.0.4.gem"
    sha256 "8569685c902108b1845be4e5794d646f2a8adcb0280d7651b600dab0844fe942"
  end

  resource "mini_portile2" do
    url "https://rubygems.org/gems/mini_portile2-2.1.0.gem"
    sha256 "0b0e83fe0fc190640a93c48cef0c8e1f1f40f77840d82c160fefc1b07a5345f8"
  end

  resource "mocha" do
    url "https://rubygems.org/gems/mocha-1.2.1.gem"
    sha256 "7de99b005aa41dc46841442afe468451a145f2c6d9b10fac0c23f0d911bef50d"
  end

  resource "moneta" do
    url "https://rubygems.org/gems/moneta-0.8.1.gem"
    sha256 "9367f8d07b550877c88d5b1560a3341543fd16ada4b60cedc892d564e0c2f52f"
  end

  resource "nokogiri" do
    url "https://rubygems.org/gems/nokogiri-1.6.8.1.gem"
    sha256 "92814a7ff672e42b60fd5c02d75b62ab8fd2df3afbac279cc8dadac3c16bbd10"
  end

  resource "oauth" do
    url "https://rubygems.org/gems/oauth-0.5.1.gem"
    sha256 "7e0a43c527af605dc1fc3ef8416d2641b400078d8a22e30981ac47d81af290ab"
  end

  resource "pango" do
    url "https://rubygems.org/gems/pango-3.1.0.gem"
    sha256 "27c362a7f257b244984e1083893f36e1e44c63f813597935265874e273010565"
  end

  resource "pkg-config" do
    url "https://rubygems.org/gems/pkg-config-1.1.7.gem"
    sha256 "1f3cd171432f4634805ebf7cd187d1d728d732bfead3837c349f2c502d8e9252"
  end

  resource "pluggaloid" do
    url "https://rubygems.org/gems/pluggaloid-1.1.1.gem"
    sha256 "f9279fad38d0bf4e20ee70e30882c6cb7916bc764bf72b2f955f0ac0ff0a3a5d"
  end

  resource "power_assert" do
    url "https://rubygems.org/gems/power_assert-0.4.1.gem"
    sha256 "8d2bf80d28a9f8bc4c6c7eb162780971896d0a27fa0540093a0f125157aa6b7f"
  end

  resource "public_suffix" do
    url "https://rubygems.org/gems/public_suffix-2.0.4.gem"
    sha256 "1d10f21372a31e54fb3e6f5cf0040954fca4bce626c7aa97679258923c8de5c5"
  end

  resource "rake" do
    url "https://rubygems.org/gems/rake-12.0.0.gem"
    sha256 "f6b43059e2923ddd30128fbbf4eb2e610c020b888ad97b57d7d94abc12734806"
  end

  resource "ruby-hmac" do
    url "https://rubygems.org/gems/ruby-hmac-0.4.0.gem"
    sha256 "a4245ecf2cfb2036975b63dc37d41426727d8449617ff45daf0b3be402a9fe07"
  end

  resource "ruby-prof" do
    url "https://rubygems.org/gems/ruby-prof-0.16.2.gem"
    sha256 "4fcd93dba70ed6f90ac030fb42798ddd4fbeceda37b15cfacccf49d5587b2378"
  end

  resource "safe_yaml" do
    url "https://rubygems.org/gems/safe_yaml-1.0.4.gem"
    sha256 "248193992ef1730a0c9ec579999ef2256a2b3a32a9bd9d708a1e12544a489ec2"
  end

  resource "test-unit" do
    url "https://rubygems.org/gems/test-unit-3.2.3.gem"
    sha256 "fe125f1418b223b9d84ea12c2557d87ccc98d2c4ae5b7ef63c75611dc4edcfce"
  end

  resource "text" do
    url "https://rubygems.org/gems/text-1.3.1.gem"
    sha256 "2fbbbc82c1ce79c4195b13018a87cbb00d762bda39241bb3cdc32792759dd3f4"
  end

  resource "totoridipjp" do
    url "https://rubygems.org/gems/totoridipjp-0.1.0.gem"
    sha256 "93d1245c5273971c855b506a7a913d23d6f524e9d7d4494127ae1bc6174c910d"
  end

  resource "twitter-text" do
    url "https://rubygems.org/gems/twitter-text-1.14.2.gem"
    sha256 "d71abba271418cbe79e28905678a6ec8ae72ccad478865f4cb3fc89f51338d52"
  end

  resource "typed-array" do
    url "https://rubygems.org/gems/typed-array-0.1.2.gem"
    sha256 "891fa1de2cdccad5f9e03936569c3c15d413d8c6658e2edfe439d9386d169b62"
  end

  resource "unf" do
    url "https://rubygems.org/gems/unf-0.1.4.gem"
    sha256 "4999517a531f2a955750f8831941891f6158498ec9b6cb1c81ce89388e63022e"
  end

  resource "unf_ext" do
    url "https://rubygems.org/gems/unf_ext-0.0.7.2.gem"
    sha256 "e8fa13d09880f8d06d30a86f929a38ba0af6abe61272927a49e6796aee1aa111"
  end

  resource "watch" do
    url "https://rubygems.org/gems/watch-0.1.0.gem"
    sha256 "1d3e767cb917f226cb970ac0e39c9ee613f9082a390598bf94be516bbd79e409"
  end

  resource "webmock" do
    url "https://rubygems.org/gems/webmock-2.3.1.gem"
    sha256 "de4c7b571a858110a47fb471dc3964af08ceb73c4303df83a1a51df3a72041a0"
  end

  def install
    (lib/"mikutter/vendor").mkpath
    resources.each do |r|
      r.verify_download_integrity(r.fetch)
      system("gem", "install", r.cached_download, "--no-document",
             "--install-dir", "#{lib}/mikutter/vendor")
    end

    rm_rf "vendor"
    (lib/"mikutter").install "plugin"
    libexec.install Dir["*"]

    (bin/"mikutter").write(exec_script)
    pkgshare.install_symlink libexec/"core/skin"
    libexec.install_symlink HOMEBREW_PREFIX/"lib/mikutter/plugin"
  end

  def exec_script
    <<-EOS.undent
    #!/bin/bash
    export GEM_HOME="#{HOMEBREW_PREFIX}/lib/mikutter/vendor"
    export DISABLE_BUNDLER_SETUP=1
    export GTK_PATH="#{HOMEBREW_PREFIX}/lib/gtk-2.0"
    exec ruby "#{libexec}/mikutter.rb" "$@"
    EOS
  end

  test do
    test_plugin = <<-EOS.undent
      # -*- coding: utf-8 -*-
      Plugin.create(:brew) do
        Delayer.new { Thread.exit }
      end
    EOS
    (testpath/"plugin/brew.rb").write(test_plugin)
    system bin/"mikutter", "--confroot=#{testpath}", "--plugin=brew", "--debug"
  end
end
