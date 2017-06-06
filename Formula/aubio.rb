class Aubio < Formula
  desc "Extract annotations from audio signals"
  homepage "https://aubio.org/"
  url "https://aubio.org/pub/aubio-0.4.5.tar.bz2"
  sha256 "70c2804e6f4fbf0ebc0fb9ac8cc9d465ef4a4d438311c074c9a7364e98827af6"

  bottle do
    cellar :any
    sha256 "a118cd7a1446f2f8dc57558e2e3e8ec151030976a04467cd2b3a32bc84903dd3" => :sierra
    sha256 "bef9b466b761bccebf7cb440ffec7d35d64bd1b579a64018924ebd80fab37a6f" => :el_capitan
    sha256 "d5ade46b9f42376b59cdbd7a44c00ab41e28218b5568f9e9caf6ab2fd4688c76" => :yosemite
  end

  option "with-python", "Build with python support"

  depends_on :macos => :lion
  depends_on "pkg-config" => :build
  depends_on "libtool" => :build
  depends_on "libav" => :optional
  depends_on "libsndfile" => :optional
  depends_on "libsamplerate" => :optional
  depends_on "fftw" => :optional
  depends_on "jack" => :optional
  depends_on "numpy" if build.with? "python"

  def install
    # Needed due to issue with recent cland (-fno-fused-madd))
    ENV.refurbish_args

    system "./waf", "configure", "--prefix=#{prefix}"
    system "./waf", "build"
    system "./waf", "install"

    if build.with? "python"
      system "python", *Language::Python.setup_install_args(prefix)
      bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
    end
  end

  test do
    if build.with? "python"
      system "#{bin}/aubiocut", "--verbose", "/System/Library/Sounds/Glass.aiff"
    end
    system "#{bin}/aubioonset", "--verbose", "/System/Library/Sounds/Glass.aiff"
  end
end
