class Getdns < Formula
  desc "Modern asynchronous DNS API"
  homepage "https://getdnsapi.net"
  revision 2

  stable do
    url "https://getdnsapi.net/releases/getdns-1-1-2/getdns-1.1.2.tar.gz"
    sha256 "685fbd493601c88c90b0bf3021ba0ee863e3297bf92f01b8bf1b3c6637c86ba5"

    # Remove for > 1.1.2
    # Upstream PR from 18 Aug 2017 "Fix issue on OS X 10.10 where TCP fast open
    # is detected but not implemented causing TCP to fail"
    patch do
      url "https://github.com/getdnsapi/getdns/pull/328.patch?full_index=1"
      sha256 "8528bc22d705502f238db7a73e9f1ddbafca398d4b133056b6b4b161adbc3929"
    end
  end

  bottle do
    sha256 "38f785b5316068f359f5b5167f2cdabf4c33add3c5a81b7f138efa44a1bfd688" => :sierra
    sha256 "d72f1b67dc14a963f08b0337e030f19e2bfbe4cb9b7d1523587f491f73f0b691" => :el_capitan
    sha256 "174bb8420ba3dca17a9d646ba06ff720332f1991406932327e0cdf34392f00cf" => :yosemite
  end

  head do
    url "https://github.com/getdnsapi/getdns.git", :branch => "develop"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "openssl"
  depends_on "unbound" => :recommended
  depends_on "libidn" => :recommended
  depends_on "libevent" => :recommended
  depends_on "libuv" => :optional
  depends_on "libev" => :optional

  def install
    if build.head?
      system "glibtoolize", "-ci"
      system "autoreconf", "-fi"
    end

    args = [
      "--with-ssl=#{Formula["openssl"].opt_prefix}",
      "--with-trust-anchor=#{etc}/getdns-root.key",
      "--without-stubby",
    ]
    args << "--enable-stub-only" if build.without? "unbound"
    args << "--without-libidn" if build.without? "libidn"
    args << "--with-libevent" if build.with? "libevent"
    args << "--with-libuv" if build.with? "libuv"
    args << "--with-libev" if build.with? "libev"

    # Current Makefile layout prevents simultaneous job execution
    # https://github.com/getdnsapi/getdns/issues/166
    ENV.deparallelize

    system "./configure", "--prefix=#{prefix}", *args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <getdns/getdns.h>

      int main(int argc, char *argv[]) {
        getdns_context *context;
        getdns_dict *api_info;
        char *pp;
        getdns_return_t r = getdns_context_create(&context, 0);
        if (r != GETDNS_RETURN_GOOD) {
            return -1;
        }
        api_info = getdns_context_get_api_information(context);
        if (!api_info) {
            return -1;
        }
        pp = getdns_pretty_print_dict(api_info);
        if (!pp) {
            return -1;
        }
        puts(pp);
        free(pp);
        getdns_dict_destroy(api_info);
        getdns_context_destroy(context);
        return 0;
      }
    EOS
    system ENV.cc, "-I#{include}", "-o", "test", "test.c", "-L#{lib}", "-lgetdns"
    system "./test"
  end
end
