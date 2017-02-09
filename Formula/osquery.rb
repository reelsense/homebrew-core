class Osquery < Formula
  desc "SQL powered operating system instrumentation and analytics"
  homepage "https://osquery.io"
  # pull from git tag to get submodules
  url "https://github.com/facebook/osquery.git",
      :tag => "2.2.1",
      :revision => "8fcb3659eeeac56847ee6d26b138b6bddc941a6a"
  revision 2

  bottle do
    cellar :any
    sha256 "cfde479725df28b5569a5dcf40cb6ff0e06c26df6df6841a2365fd366dd12448" => :sierra
    sha256 "77340345489f1824a9f51363f9726968fca053a017d9408564c7dac5af52cc2a" => :el_capitan
    sha256 "63f5fc2f0971ffce5e8b6a4ac7c698601442c63b8146e58e43cc44f8f4a2ce25" => :yosemite
  end

  fails_with :gcc => "6"

  # osquery only supports OS X 10.9 and above. Do not remove this.
  depends_on :macos => :mavericks
  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "asio"
  depends_on "augeas"
  depends_on "snappy"
  depends_on "gflags"
  depends_on "glog"
  depends_on "libmagic"
  depends_on "lz4"
  depends_on "openssl"
  depends_on "rocksdb"
  depends_on "sleuthkit"
  depends_on "yara"
  depends_on "xz"

  resource "MarkupSafe" do
    url "https://files.pythonhosted.org/packages/c0/41/bae1254e0396c0cc8cf1751cb7d9afc90a602353695af5952530482c963f/MarkupSafe-0.23.tar.gz"
    sha256 "a4ec1aff59b95a14b45eb2e23761a0179e98319da5a7eb76b56ea8cdc7b871c3"
  end

  resource "Jinja2" do
    url "https://files.pythonhosted.org/packages/5f/bd/5815d4d925a2b8cbbb4b4960f018441b0c65f24ba29f3bdcfb3c8218a307/Jinja2-2.8.1.tar.gz"
    sha256 "35341f3a97b46327b3ef1eb624aadea87a535b8f50863036e085e7c426ac5891"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/d9/c8/8c7a2ab8ec108ba9ab9a4762c5a0d67c283d41b13b5ce46be81fdcae3656/psutil-5.0.1.tar.gz"
    sha256 "9d8b7f8353a2b2eb6eb7271d42ec99d0d264a9338a37be46424d56b4e473b39e"
  end

  resource "aws-sdk-cpp" do
    url "https://github.com/aws/aws-sdk-cpp/archive/0.14.4.tar.gz"
    sha256 "2e935275c6f7eb25e7d850b354344c92cacb7c193b708ec64ffce10ec6afa7f4"
  end

  resource "boost" do
    url "https://downloads.sourceforge.net/project/boost/boost/1.62.0/boost_1_62_0.tar.bz2"
    sha256 "36c96b0f6155c98404091d8ceb48319a28279ca0333fba1ad8611eb90afb2ca0"
  end

  resource "cpp-netlib" do
    url "https://github.com/cpp-netlib/cpp-netlib/archive/cpp-netlib-0.12.0-final.tar.gz"
    version "0.12.0"
    sha256 "d66e264240bf607d51b8d0e743a1fa9d592d96183d27e2abdaf68b0a87e64560"
  end

  resource "linenoise" do
    url "https://github.com/theopolis/linenoise-ng/archive/v1.0.1.tar.gz"
    sha256 "c317f3ec92dcb4244cb62f6fb3b7a0a5a53729a85842225fcfce0d4a429a0dfa"
  end

  resource "thrift" do
    url "https://www.apache.org/dyn/closer.cgi?path=/thrift/0.9.3/thrift-0.9.3.tar.gz"
    sha256 "b0740a070ac09adde04d43e852ce4c320564a292f26521c46b78e0641564969e"
  end

  resource "thrift-patch" do
    url "https://gist.githubusercontent.com/ilovezfs/1d098a46e30b9e8bf78d4871e541d2fe/raw/3f5cf999f36aed3f2b5a477bafa6f9c16862649b/gistfile1.txt"
    sha256 "61955afa09ef244fc84a72ef019de15515e76377aceeb2cbf1e93fa0df374cd2"
  end

  def install
    ENV.cxx11

    vendor = buildpath/"brew_vendor"

    resource("aws-sdk-cpp").stage do
      inreplace "CMakeLists.txt", "${CMAKE_CXX_FLAGS_RELEASE} -s",
                                  "${CMAKE_CXX_FLAGS_RELEASE}"

      args = std_cmake_args + %W[
        -DSTATIC_LINKING=1
        -DNO_HTTP_CLIENT=1
        -DMINIMIZE_SIZE=ON
        -DBUILD_SHARED_LIBS=OFF
        -DBUILD_ONLY=firehose;kinesis;sts
        -DCMAKE_INSTALL_PREFIX=#{vendor}/aws-sdk-cpp
      ]

      mkdir "build" do
        system "cmake", "..", *args
        system "make"
        system "make", "install"
      end
    end

    resource("boost").stage do
      # Force boost to compile with the desired compiler
      open("user-config.jam", "a") do |file|
        file.write "using darwin : : #{ENV.cxx} ;\n"
        file.write "using mpi ;\n" if build.with? "mpi"
      end

      bootstrap_args = %W[
        --without-icu
        --prefix=#{vendor}/boost
        --libdir=#{vendor}/boost/lib
        --with-libraries=filesystem,regex,system
      ]

      args = %W[
        --prefix=#{vendor}/boost
        --libdir=#{vendor}/boost/lib
        -d2
        -j#{ENV.make_jobs}
        --ignore-site-config
        --layout=tagged
        --user-config=user-config.jam
        install
        threading=multi
        link=static
        optimization=space
        variant=release
        cxxflags=-std=c++11
      ]

      if ENV.compiler == :clang
        args << "cxxflags=-stdlib=libc++" << "linkflags=-stdlib=libc++"
      end

      system "./bootstrap.sh", *bootstrap_args
      system "./b2", "headers"
      system "./b2", *args
    end

    resource("cpp-netlib").stage do
      ENV["BOOST_ROOT"] = vendor/"boost"
      args = std_cmake_args + %W[
        -DCMAKE_INSTALL_PREFIX=#{vendor}/cpp-netlib
        -DCPP-NETLIB_BUILD_TESTS=OFF
        -DCPP-NETLIB_BUILD_EXAMPLES=OFF
      ]
      system "cmake", ".", *args
      system "make"
      system "make", "install"
    end

    resource("linenoise").stage do
      mkdir "build" do
        args = std_cmake_args + %W[
          -DCMAKE_INSTALL_PREFIX=#{vendor}/linenoise
          -DCMAKE_CXX_FLAGS=-mno-avx\ -fPIC
        ]
        system "cmake", "..", *args
        system "make"
        system "make", "install"
      end
    end

    resource("thrift").stage do
      ENV["PY_PREFIX"] = vendor/"thrift"
      ENV.append "CPPFLAGS", "-DOPENSSL_NO_SSL3"

      # Remove SSLv3
      # See https://github.com/apache/thrift/commit/b819260c653f6fd9602419ee2541060ecb930c4c
      Pathname.pwd.install resource("thrift-patch")
      system "patch", "-p1", "-i", "gistfile1.txt"

      exclusions = %W[
        --without-ruby
        --disable-tests
        --without-php_extension
        --without-haskell
        --without-java
        --without-perl
        --without-php
        --without-erlang
        --without-go
        --without-qt
        --without-qt4
        --without-nodejs
        --with-cpp
        --with-python
        --with-openssl=#{Formula["openssl"].opt_prefix}
      ]

      ENV.prepend_path "PATH", Formula["bison"].opt_bin
      system "./configure", "--disable-debug",
                            "--prefix=#{vendor}/thrift",
                            "--libdir=#{vendor}/thrift/lib",
                            "--with-boost=#{vendor}/boost",
                            *exclusions
      system "make", "-j#{ENV.make_jobs}"
      system "make", "install"
    end
    ENV.prepend_path "PATH", vendor/"thrift/bin"

    # Skip test and benchmarking.
    ENV["SKIP_TESTS"] = "1"

    ENV.prepend_create_path "PYTHONPATH", buildpath/"third-party/python/lib/python2.7/site-packages"
    ENV["THRIFT_HOME"] = vendor/"thrift"

    res = resources.map(&:name).to_set - %w[aws-sdk-cpp boost cpp-netlib
                                            linenoise thrift thrift-patch]
    res.each do |r|
      resource(r).stage do
        system "python", "setup.py", "install",
                                 "--prefix=#{buildpath}/third-party/python/",
                                 "--single-version-externally-managed",
                                 "--record=installed.txt"
      end
    end

    ENV["BOOST_ROOT"] = vendor/"boost/include"

    args = std_cmake_args + %W[
      -Daws-cpp-sdk-core_library:FILEPATH=#{vendor}/aws-sdk-cpp/lib/libaws-cpp-sdk-core.a
      -Daws-cpp-sdk-firehose_library:FILEPATH=#{vendor}/aws-sdk-cpp/lib/libaws-cpp-sdk-firehose.a
      -Daws-cpp-sdk-kinesis_library:FILEPATH=#{vendor}/aws-sdk-cpp/lib/libaws-cpp-sdk-kinesis.a
      -Daws-cpp-sdk-sts_library:FILEPATH=#{vendor}/aws-sdk-cpp/lib/libaws-cpp-sdk-sts.a
      -Dboost_filesystem-mt_library:FILEPATH=#{vendor}/boost/lib/libboost_filesystem-mt.a
      -Dboost_regex-mt_library:FILEPATH=#{vendor}/boost/lib/libboost_regex-mt.a
      -Dboost_system-mt_library:FILEPATH=#{vendor}/boost/lib/libboost_system-mt.a
      -Dcppnetlib-client-connections_library:FILEPATH=#{vendor}/cpp-netlib/lib/libcppnetlib-client-connections.a
      -Dcppnetlib-uri_library:FILEPATH=#{vendor}/cpp-netlib/lib/libcppnetlib-uri.a
      -Dlinenoise_library:FILEPATH=#{vendor}/linenoise/lib/liblinenoise.a
      -Dthrift_library:FILEPATH=#{vendor}/thrift/lib/libthrift.a
      -DCMAKE_CXX_FLAGS_RELEASE:STRING=-DNDEBUG\ -I#{MacOS.sdk_path}/usr/include/libxml2\ -I#{vendor}/aws-sdk-cpp/include\ -I#{vendor}/boost/include\ -I#{vendor}/cpp-netlib/include\ -I#{vendor}/linenoise/include\ -I#{vendor}/thrift/include\ -Wl,-L#{vendor}/linenoise/lib
    ]

    # Link dynamically against brew-installed libraries.
    ENV["BUILD_LINK_SHARED"] = "1"

    system "cmake", ".", *args
    system "make"
    system "make", "install"
    (include/"osquery/core").install Dir["osquery/core/*.h"]
  end

  plist_options :startup => true, :manual => "osqueryd"

  test do
    assert_match "platform_info", shell_output("#{bin}/osqueryi -L")
  end
end
