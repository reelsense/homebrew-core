class Mikutter < Formula
  desc "Extensible Twitter client"
  homepage "https://mikutter.hachune.net/"
  url "https://mikutter.hachune.net/bin/mikutter.3.5.10.tar.gz"
  sha256 "d794153f17e110b6696b0bf1a050817cc61dd14127cbfdcd12e566656b30bc53"
  head "git://toshia.dip.jp/mikutter.git", :branch => "develop"

  bottle do
    sha256 "aed5a9e83e5d098492b55aacd3141fa219673e3168322d4bbcae3e2bf3cd91e9" => :sierra
    sha256 "7f15b973195df834bac7b9400dab412d9808249b0efb1c07bdecb03719a21f53" => :el_capitan
    sha256 "da9df581f4f471799675f1097cb5bb26239c96c61d69cec81324c48e54d49f4f" => :yosemite
  end

  depends_on "gtk+"
  depends_on "terminal-notifier" => :recommended
  depends_on :ruby => "2.1"

  resource "addressable" do
    url "https://rubygems.org/gems/addressable-2.5.2.gem"
    sha256 "73771ea960b3900d96e6b3729bd203e66f387d0717df83304411bf37efd7386e"
  end

  resource "atk" do
    url "https://rubygems.org/gems/atk-3.1.8.gem"
    sha256 "598a956506066e43037099899247031850e2ec764d3007f39d975fe01c5c367a"
  end

  resource "cairo" do
    url "https://rubygems.org/gems/cairo-1.15.9.gem"
    sha256 "579727200f724a4da0c259e59bb79289de35ede0668dbe4b08883cc8e3b35325"
  end

  resource "cairo-gobject" do
    url "https://rubygems.org/gems/cairo-gobject-3.1.8.gem"
    sha256 "a27bd60e70b02b399db7f70a7d7ac6b171a4556ed46a3ff06ae8cef85262ab0d"
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
    url "https://rubygems.org/gems/gdk_pixbuf2-3.1.8.gem"
    sha256 "3e7f59479224b62ca27b6078aa527e285b6e81dbbe36b04f0f02047cb2d6e5de"
  end

  resource "gettext" do
    url "https://rubygems.org/gems/gettext-3.2.4.gem"
    sha256 "ffd3f6dd5b8e73dd8117ac2a7f7caabae1118de85624d47b7163f9ace1c4dd77"
  end

  resource "gio2" do
    url "https://rubygems.org/gems/gio2-3.1.8.gem"
    sha256 "97aa3245e39f2d94d569960fa780b6335c007f9039f720901f77619854242a8c"
  end

  resource "glib2" do
    url "https://rubygems.org/gems/glib2-3.1.8.gem"
    sha256 "fbb5ef561b82ff22280da9997927b71f6e7c872f0e1c36887c1ed760f07d72f5"
  end

  resource "gobject-introspection" do
    url "https://rubygems.org/gems/gobject-introspection-3.1.8.gem"
    sha256 "64397426f137e4b933b5a3d5d07915907e7b2705a72f7d3e0743609cf075e54e"
  end

  resource "gtk2" do
    url "https://rubygems.org/gems/gtk2-3.1.8.gem"
    sha256 "f93dbd54cdddc21b0e837cc1c66ceb220ffaa59a45562d7a18ce985889de2174"
  end

  resource "hashdiff" do
    url "https://rubygems.org/gems/hashdiff-0.3.6.gem"
    sha256 "816ce4c22faeb0df029170dd101e34d238b90b388556ecde77413c373d5e1870"
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
    url "https://rubygems.org/gems/json_pure-2.1.0.gem"
    sha256 "5a895821c7d6200764facf1a85d81e2696ef71701b08da479582910cab4bce8b"
  end

  resource "locale" do
    url "https://rubygems.org/gems/locale-2.1.2.gem"
    sha256 "1db4a6b5f21fcd64f397d61bf2af69840dc11b3176d1fa6d75a0e749f04a9aea"
  end

  resource "memoist" do
    url "https://rubygems.org/gems/memoist-0.16.0.gem"
    sha256 "70bd755b48477c9ef9601daa44d298e04a13c1727f8f9d38c34570043174085f"
  end

  resource "metaclass" do
    url "https://rubygems.org/gems/metaclass-0.0.4.gem"
    sha256 "8569685c902108b1845be4e5794d646f2a8adcb0280d7651b600dab0844fe942"
  end

  resource "mini_portile2" do
    url "https://rubygems.org/gems/mini_portile2-2.2.0.gem"
    sha256 "f536d3307de76d8ec8cbcc9182a88d83bdc0f8f6e3e9681560166004fcbbab3c"
  end

  resource "mocha" do
    url "https://rubygems.org/gems/mocha-1.3.0.gem"
    sha256 "22f247ad94e92cef32baac2e671d1d7262f165dc933ead1940cf874c3d1fc25e"
  end

  resource "moneta" do
    url "https://rubygems.org/gems/moneta-1.0.0.gem"
    sha256 "2224e5a68156e8eceb525fb0582c8c4e0f29f67cae86507cdcfb406abbb1fc5d"
  end

  resource "native-package-installer" do
    url "https://rubygems.org/gems/native-package-installer-1.0.4.gem"
    sha256 "4a20c4c74681d60075cad4b435f64278e6b09813edef8c41a23f1e7f9e16726b"
  end

  resource "nokogiri" do
    url "https://rubygems.org/gems/nokogiri-1.8.0.gem"
    sha256 "d6e693278e3c26f828339705e14a149de5ac824771e59c6cd9e6c91ebad7ced9"
  end

  resource "oauth" do
    url "https://rubygems.org/gems/oauth-0.5.3.gem"
    sha256 "0b3412bf8114cc9c87abebae4b858216a9bf453192ea3069d5bd8e7ad373aca8"
  end

  resource "pango" do
    url "https://rubygems.org/gems/pango-3.1.8.gem"
    sha256 "329d9b28ba6b4d6775cdd1ab81df8a4e92c8d9d3a69b6de682c9f9ddbfde988a"
  end

  resource "pkg-config" do
    url "https://rubygems.org/gems/pkg-config-1.2.7.gem"
    sha256 "fc8ab6f3200cddfeacb8a29168daa38d8f76c0e09af91a00a3d423bc472d70af"
  end

  resource "pluggaloid" do
    url "https://rubygems.org/gems/pluggaloid-1.1.1.gem"
    sha256 "f9279fad38d0bf4e20ee70e30882c6cb7916bc764bf72b2f955f0ac0ff0a3a5d"
  end

  resource "power_assert" do
    url "https://rubygems.org/gems/power_assert-1.1.0.gem"
    sha256 "e541ceb7b0cf03331c3ab146f022e4705cff0d7eea3c79017459130b31ced96b"
  end

  resource "public_suffix" do
    url "https://rubygems.org/gems/public_suffix-3.0.0.gem"
    sha256 "ae48d8122866e342c09f1f643c2b88e3547562fd6df85d83926445d75f90ca6a"
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
    url "https://rubygems.org/gems/test-unit-3.2.5.gem"
    sha256 "a230fc4f832ca770bf0bdcd82dd6e83f48fb24cf4e6e883bf83806c09d197d15"
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
    url "https://rubygems.org/gems/twitter-text-1.14.7.gem"
    sha256 "6fbf511d449d61a2e2198dd758622193aa74d6e95a6ec7111725cce0e181629c"
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
    url "https://rubygems.org/gems/unf_ext-0.0.7.4.gem"
    sha256 "8b3e34ddcc5db65c6e0c9f34b5bd62720e770ba04843d601c3730c887f131992"
  end

  resource "watch" do
    url "https://rubygems.org/gems/watch-0.1.0.gem"
    sha256 "1d3e767cb917f226cb970ac0e39c9ee613f9082a390598bf94be516bbd79e409"
  end

  resource "webmock" do
    url "https://rubygems.org/gems/webmock-3.0.1.gem"
    sha256 "53b2422e7b07a318f43d7bb9cbb3cf82ecfdaffa5f085c69b426db9e8efc463f"
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
    libexec.install_symlink lib/"mikutter/plugin"
  end

  def exec_script
    <<-EOS.undent
    #!/bin/bash
    export GEM_HOME="#{opt_lib}/mikutter/vendor"
    export DISABLE_BUNDLER_SETUP=1
    export GTK_PATH="#{Formula["gtk+"].opt_lib}/gtk-2.0"
    exec ruby "#{libexec}/mikutter.rb" "$@"
    EOS
  end

  test do
    (testpath/"test_plugin").write <<-EOS.undent
      # -*- coding: utf-8 -*-
      Plugin.create(:brew) do
        Delayer.new { Thread.exit }
      end
    EOS
    system bin/"mikutter", "generate", "test_plugin"
    assert File.file?(testpath/".mikutter/plugin/test_plugin/test_plugin.rb")
    system bin/"mikutter", "plugin_depends",
           testpath/".mikutter/plugin/test_plugin/test_plugin.rb"
  end
end
