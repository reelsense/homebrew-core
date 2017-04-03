class Notmuch < Formula
  desc "Thread-based email index, search, and tagging"
  homepage "https://notmuchmail.org"
  url "https://notmuchmail.org/releases/notmuch-0.24.1.tar.gz"
  sha256 "fa117de2c6096dd896a333b9c770572a939e04a02abe6745b6b07f5363063ca3"
  head "git://git.notmuchmail.org/git/notmuch"

  bottle do
    cellar :any
    sha256 "0fb3360c41dfc3ed91420875b3ec74f78c124743e79036c30248f49a4ce9bf45" => :sierra
    sha256 "087c52f7178efd621eab51187406332380134cc08f2759af4a488294db39bd95" => :el_capitan
    sha256 "58440c1e81a60042efc6cada19db917d9af7c9094ee7a7dc7cc7be5e1a7f24f4" => :yosemite
  end

  option "without-python", "Build without python support"

  depends_on "pkg-config" => :build
  depends_on "gmime"
  depends_on "talloc"
  depends_on "xapian"
  depends_on :emacs => ["24.1", :optional]
  depends_on :python3 => :optional
  depends_on :ruby => ["1.9", :optional]

  # Requires zlib >= 1.2.11
  resource "zlib" do
    url "http://zlib.net/zlib-1.2.11.tar.gz"
    sha256 "c3e5e9fdd5004dcb542feda5ee4f0ff0744628baf8ed2dd5d66f8ca1197cb1a1"
  end

  # Fix SIP issue with python bindings
  # A more comprehensive patch has been submitted upstream
  # https://notmuchmail.org/pipermail/notmuch/2016/022631.html
  patch :DATA

  def install
    resource("zlib").stage do
      system "./configure", "--prefix=#{buildpath}/zlib", "--static"
      system "make", "install"
      ENV.append_path "PKG_CONFIG_PATH", "#{buildpath}/zlib/lib/pkgconfig"
    end

    args = %W[--prefix=#{prefix}]

    if build.with? "emacs"
      ENV.deparallelize # Emacs and parallel builds aren't friends
      args << "--with-emacs" << "--emacslispdir=#{elisp}" << "--emacsetcdir=#{elisp}"
    else
      args << "--without-emacs"
    end

    args << "--without-ruby" if build.without? "ruby"

    system "./configure", *args
    system "make", "V=1", "install"

    Language::Python.each_python(build) do |python, _version|
      cd "bindings/python" do
        system python, *Language::Python.setup_install_args(prefix)
      end
    end
  end

  test do
    (testpath/".notmuch-config").write "[database]\npath=#{testpath}/Mail"
    (testpath/"Mail").mkpath
    assert_match "0 total", shell_output("#{bin}/notmuch new")
  end
end

__END__
diff --git a/bindings/python/notmuch/globals.py b/bindings/python/notmuch/globals.py
index b1eec2c..bce5190 100644
--- a/bindings/python/notmuch/globals.py
+++ b/bindings/python/notmuch/globals.py
@@ -25,7 +25,7 @@ from notmuch.version import SOVERSION
 try:
     from os import uname
     if uname()[0] == 'Darwin':
-        nmlib = CDLL("libnotmuch.{0:s}.dylib".format(SOVERSION))
+        nmlib = CDLL("HOMEBREW_PREFIX/lib/libnotmuch.{0:s}.dylib".format(SOVERSION))
     else:
         nmlib = CDLL("libnotmuch.so.{0:s}".format(SOVERSION))
 except:
