class GetFlashVideos < Formula
  desc "Download or play videos from various Flash-based websites"
  homepage "https://github.com/monsieurvideo/get-flash-videos"
  url "https://github.com/monsieurvideo/get-flash-videos/archive/1.25.95.tar.gz"
  sha256 "91387775fbe8fc422a4cf93b9df7f39f2e66f7260688ef2bf44e275a5d374ac8"

  bottle do
    cellar :any_skip_relocation
    sha256 "6bc6578ecf23b5b242c3a7ef7f198a9ad350f8e6206b251cf3618efac6aa6067" => :high_sierra
    sha256 "4b8ac3991e15b1c9ffbd7293a5f0ba11c3475ba29f91bff15001d56cf48a4d1e" => :sierra
    sha256 "a23749a01162ad076f8fd42ceb65b9cd20fce9b3777d4a8719324c97ed5a2517" => :el_capitan
  end

  depends_on "rtmpdump"

  resource "Crypt::Blowfish_PP" do
    url "https://cpan.metacpan.org/authors/id/M/MA/MATTBM/Crypt-Blowfish_PP-1.12.tar.gz"
    sha256 "714f1a3e94f658029d108ca15ed20f0842e73559ae5fc1faee86d4f2195fcf8c"
  end

  resource "LWP::Protocol" do
    url "https://cpan.metacpan.org/authors/id/E/ET/ETHER/libwww-perl-6.31.tar.gz"
    sha256 "525d5386d39d1c1d7da8a0e9dd0cbab95cba2a4bfcfd9b83b257f49be4eecae3"
  end

  resource "Tie::IxHash" do
    url "https://cpan.metacpan.org/authors/id/C/CH/CHORNY/Tie-IxHash-1.23.tar.gz"
    sha256 "fabb0b8c97e67c9b34b6cc18ed66f6c5e01c55b257dcf007555e0b027d4caf56"
  end

  resource "WWW::Mechanize" do
    url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/WWW-Mechanize-1.86.tar.gz"
    sha256 "0e5468b89afeff096fb6d9b91a9a58418746c89445fb01adb5caa25ecf32d469"
  end

  resource "Term::ProgressBar" do
    url "https://cpan.metacpan.org/authors/id/M/MA/MANWAR/Term-ProgressBar-2.21.tar.gz"
    sha256 "66994f1a6ca94d8d92e3efac406142fb0d05033360c0acce2599862db9c30e44"
  end

  resource "Class::MethodMaker" do
    url "https://cpan.metacpan.org/authors/id/S/SC/SCHWIGON/class-methodmaker/Class-MethodMaker-2.24.tar.gz"
    sha256 "5eef58ccb27ebd01bcde5b14bcc553b5347a0699e5c3e921c7780c3526890328"
  end

  def install
    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"
    resources.each do |r|
      r.stage do
        system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
        system "make"
        system "make", "install"
      end
    end

    ENV.prepend_create_path "PERL5LIB", lib/"perl5"
    system "make"
    (lib/"perl5").install "blib/lib/FlashVideo"

    bin.install "bin/get_flash_videos"
    bin.env_script_all_files(libexec/"bin", :PERL5LIB => ENV["PERL5LIB"])
    chmod 0755, libexec/"bin/get_flash_videos"

    man1.install "blib/man1/get_flash_videos.1"
  end

  test do
    file = testpath/"BBC_-__Do_whatever_it_takes_to_get_him_to_talk.flv"
    system bin/"get_flash_videos", "http://news.bbc.co.uk/2/hi/programmes/hardtalk/9560793.stm"
    assert_predicate file, :exist?, "Failed to download #{file}!"
  end
end
