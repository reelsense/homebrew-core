class Tarantool < Formula
  desc "In-memory database and Lua application server."
  homepage "https://tarantool.org/"
  url "https://download.tarantool.org/tarantool/1.7/src/tarantool-1.7.4.18.tar.gz"
  sha256 "5a1703190a42bac570cc1cbf9a76b62a488723db1a671db39071ed5a5a36d344"

  head "https://github.com/tarantool/tarantool.git", :branch => "1.8", :shallow => false

  bottle do
    sha256 "97334f7dad632e4f62eaa5b5628730e3324b55cbdf5dd3b0fd147e179f90ac92" => :sierra
    sha256 "a662cb44c57f87508b8a59681571a1c027f9697a97d9dfebac1198533affb49d" => :el_capitan
    sha256 "98131249c1fd87bf1ff8400331deb6346ad4402faeba5ee442bc62a7976b62bb" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "openssl"
  depends_on "readline"

  def install
    args = std_cmake_args

    args << "-DCMAKE_INSTALL_MANDIR=#{doc}"
    args << "-DCMAKE_INSTALL_SYSCONFDIR=#{etc}"
    args << "-DCMAKE_INSTALL_LOCALSTATEDIR=#{var}"
    args << "-DENABLE_DIST=ON"
    args << "-DOPENSSL_ROOT_DIR=#{Formula["openssl"].opt_prefix}"
    args << "-DREADLINE_ROOT=#{Formula["readline"].opt_prefix}"

    system "cmake", ".", *args
    system "make"
    system "make", "install"
  end

  def post_install
    local_user = ENV["USER"]
    inreplace etc/"default/tarantool", /(username\s*=).*/, "\\1 '#{local_user}'"

    (var/"lib/tarantool").mkpath
    (var/"log/tarantool").mkpath
    (var/"run/tarantool").mkpath
  end

  test do
    (testpath/"test.lua").write <<-EOS.undent
        box.cfg{}
        local s = box.schema.create_space("test")
        s:create_index("primary")
        local tup = {1, 2, 3, 4}
        s:insert(tup)
        local ret = s:get(tup[1])
        if (ret[3] ~= tup[3]) then
          os.exit(-1)
        end
        os.exit(0)
    EOS
    system bin/"tarantool", "#{testpath}/test.lua"
  end
end
