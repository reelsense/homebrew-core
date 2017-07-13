class Libgit2Glib < Formula
  desc "Glib wrapper library around libgit2 git access library"
  homepage "https://github.com/GNOME/libgit2-glib"
  revision 1

  stable do
    url "https://download.gnome.org/sources/libgit2-glib/0.25/libgit2-glib-0.25.0.tar.xz"
    sha256 "4a256b9acfb93ea70d37213a4083e2310e59b05f2c7595242fe3c239327bc565"

    # Remove for > 0.25.0
    # Upstream commit from 8 Jul 2017 for libgit 0.26.0 compatibility
    # See https://bugzilla.gnome.org/show_bug.cgi?id=784706
    patch do
      url "https://github.com/GNOME/libgit2-glib/commit/995b33c.patch?full_index=1"
      sha256 "2f878912a5497ce9e27c45c14e512201cde24f3acfdaaae171eddf53d15e4d53"
    end
  end

  bottle do
    sha256 "8db724848fe735443da4dcc29c42470fcb105044e713bfacce46daaae5db462e" => :sierra
    sha256 "9de8bae017a7c7c0eef1190823ffd36f857d3fe7a7f33ce7413e702e308245cb" => :el_capitan
    sha256 "cc8c2c3e286e8880e81f8b2e49469218df520d54724bda04b2a8bccca3ec9fbb" => :yosemite
  end

  head do
    url "https://github.com/GNOME/libgit2-glib.git"

    depends_on "libtool" => :build
    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "gnome-common" => :build
    depends_on "gtk-doc" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "libgit2"
  depends_on "gobject-introspection"
  depends_on "glib"
  depends_on "vala" => :optional
  depends_on :python => :optional

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-silent-rules
      --disable-dependency-tracking
    ]

    args << "--enable-python=no" if build.without? "python"
    args << "--enable-vala=no" if build.without? "vala"

    system "./autogen.sh", *args if build.head?
    system "./configure", *args if build.stable?
    system "make", "install"

    libexec.install "examples/.libs", "examples/clone", "examples/general", "examples/walk"
  end

  test do
    mkdir "horatio" do
      system "git", "init"
    end
    system "#{libexec}/general", testpath/"horatio"
  end
end
