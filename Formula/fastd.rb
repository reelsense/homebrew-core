class Fastd < Formula
  desc "Fast and Secure Tunnelling Daemon"
  homepage "https://projects.universe-factory.net/projects/fastd"
  url "https://projects.universe-factory.net/attachments/download/86/fastd-18.tar.xz"
  sha256 "714ff09d7bd75f79783f744f6f8c5af2fe456c8cf876feaa704c205a73e043c9"
  head "https://git.universe-factory.net/fastd/", :using => :git

  bottle do
    cellar :any
    revision 2
    sha256 "c89ecf6a83289f7d4fee098474304e41f58799031b3468d0147884848d60e825" => :mavericks
  end

  depends_on "cmake" => :build
  depends_on "libuecc"
  depends_on "libsodium"
  depends_on "bison" => :build # fastd requires bison >= 2.5
  depends_on "pkg-config" => :build
  depends_on "json-c"
  depends_on "openssl" => :optional
  depends_on :tuntap => :recommended

  def install
    args = std_cmake_args
    args << "-DENABLE_LTO=ON"
    args << "-DENABLE_OPENSSL=ON" if build.with? "openssl"
    args << buildpath
    mkdir "fastd-build" do
      system "cmake", *args
      system "make"
      system "make", "install"
    end
  end

  test do
    system "#{bin}/fastd", "--generate-key"
  end
end
