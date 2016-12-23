class Pixman < Formula
  desc "Low-level library for pixel manipulation"
  homepage "https://cairographics.org/"
  url "https://cairographics.org/releases/pixman-0.34.0.tar.gz"
  sha256 "21b6b249b51c6800dc9553b65106e1e37d0e25df942c90531d4c3997aa20a88e"

  bottle do
    cellar :any
    sha256 "345c55cb038be8ad3cea956647fcbe8f06db0df61b7dda1a8d7da2f40efc0c3b" => :sierra
    sha256 "ce36799e5a38be394c20f7196f93c2bcfbf9a0a49c7964e59ab8980fb81cda26" => :el_capitan
    sha256 "d9db47ff106386a945bc74d1717a9215a6de5bdcc848aea99ef10d31ae480ef4" => :yosemite
    sha256 "810b4e5d428e6be2987e96767adf8bca06dd026fbcc5246f96d8d5ec4f64962c" => :mavericks
  end

  keg_only :provided_pre_mountain_lion

  option :universal

  depends_on "pkg-config" => :build

  def install
    ENV.universal_binary if build.universal?

    system "./configure", "--disable-dependency-tracking",
                          "--disable-gtk",
                          "--disable-mmx", # MMX assembler fails with Xcode 7
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <pixman.h>

      int main(int argc, char *argv[])
      {
        pixman_color_t white = { 0xffff, 0xffff, 0xffff, 0xffff };
        pixman_image_t *image = pixman_image_create_solid_fill(&white);
        pixman_image_unref(image);
        return 0;
      }
    EOS
    flags = %W[
      -I#{include}/pixman-1
      -L#{lib}
      -lpixman-1
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
