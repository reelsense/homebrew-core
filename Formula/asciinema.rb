class Asciinema < Formula
  desc "Record and share terminal sessions"
  homepage "https://asciinema.org"
  url "https://github.com/asciinema/asciinema/archive/v1.3.0.tar.gz"
  sha256 "968016828119d53b8e4e6ccf40a2635704d236f8e805f635c15adc09a4373a55"
  revision 1
  head "https://github.com/asciinema/asciinema.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "20800a64e58bb2c662007fb6dcd8ed9eeb503a7b0ffc1aab8c7b8f917696679b" => :sierra
    sha256 "20401e81d70e056156dc8ef6c0ccc650971185b2ba21c253f047939db6942c99" => :el_capitan
    sha256 "20401e81d70e056156dc8ef6c0ccc650971185b2ba21c253f047939db6942c99" => :yosemite
  end

  depends_on :python3

  def install
    xy = Language::Python.major_minor_version "python3"
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python#{xy}/site-packages"
    system "python3", *Language::Python.setup_install_args(libexec)

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    ENV["LC_ALL"] = "en_US.UTF-8"
    system "#{bin}/asciinema", "--version"
    system "#{bin}/asciinema", "--help"
  end
end
