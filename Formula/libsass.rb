class Libsass < Formula
  desc "C implementation of a Sass compiler"
  homepage "https://github.com/sass/libsass"
  url "https://github.com/sass/libsass.git", :tag => "3.4.3", :revision => "b28de01270a663b3e89427a18816732c4d573c1d"
  head "https://github.com/sass/libsass.git"

  bottle do
    cellar :any
    sha256 "1bf8fdd91e81a6ae71c0b285bf9bda4892d2d5fa152ed9cd9eb99c8a0588bcf6" => :sierra
    sha256 "d6818e9a5872d39f02be581e6d31cc8942c158abfc428d8e662454248ae97c87" => :el_capitan
    sha256 "030c6b49661b482562fb1ce2d2e2ca383dada5124a78439a4b7afa2eb7e6312d" => :yosemite
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  needs :cxx11

  def install
    ENV.cxx11
    system "autoreconf", "-fvi"
    system "./configure", "--prefix=#{prefix}", "--disable-silent-rules",
                          "--disable-dependency-tracking"
    system "make", "install"
  end

  test do
    # This will need to be updated when devel = stable due to API changes.
    (testpath/"test.c").write <<-EOS.undent
      #include <sass/context.h>
      #include <string.h>

      int main()
      {
        const char* source_string = "a { color:blue; &:hover { color:red; } }";
        struct Sass_Data_Context* data_ctx = sass_make_data_context(strdup(source_string));
        struct Sass_Options* options = sass_data_context_get_options(data_ctx);
        sass_option_set_precision(options, 1);
        sass_option_set_source_comments(options, false);
        sass_data_context_set_options(data_ctx, options);
        sass_compile_data_context(data_ctx);
        struct Sass_Context* ctx = sass_data_context_get_context(data_ctx);
        int err = sass_context_get_error_status(ctx);
        if(err != 0) {
          return 1;
        } else {
          return strcmp(sass_context_get_output_string(ctx), "a {\\n  color: blue; }\\n  a:hover {\\n    color: red; }\\n") != 0;
        }
      }
    EOS
    system ENV.cc, "-o", "test", "test.c", "-lsass"
    system "./test"
  end
end
