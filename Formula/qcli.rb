class Qcli < Formula
  desc "Report audiovisual metrics via libavfilter"
  homepage "https://bavc.org/preserve-media/preservation-tools"
  url "https://github.com/bavc/qctools/archive/v0.8.tar.gz"
  sha256 "5362dc8325aeb37e0742a5e5df7b831e7fe82a7b06c72c50463a43a7ad0b56bc"
  head "https://github.com/bavc/qctools.git"

  bottle do
    cellar :any
    sha256 "7a9637cd76b12c80f8d8827d0742f2045f28d8d2582052787b0455b124e8af39" => :sierra
    sha256 "91e36418ed0a3290a6da316c5948c4f200a93e3f5ad250012afae8450ac2458b" => :el_capitan
    sha256 "9757043d262d517856e343206ae9ed580dad634894c330cd12b278acfdb23796" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "qwt"
  depends_on "qt"
  depends_on "ffmpeg"

  def install
    ENV["QCTOOLS_USE_BREW"]="true"

    cd "Project/QtCreator/qctools-lib" do
      system "qmake", "qctools-lib.pro"
      system "make"
    end
    cd "Project/QtCreator/qctools-cli" do
      system "qmake", "qctools-cli.pro"
      system "make"
      bin.install "qcli"
    end
  end

  test do
    # Create an example mp4 file
    mp4out = testpath/"video.mp4"
    system "ffmpeg", "-filter_complex", "testsrc=rate=1:duration=1", mp4out
    # Create a qcli report from the mp4
    qcliout = testpath/"video.mp4.qctools.xml.gz"
    system bin/"qcli", "-i", mp4out, "-o", qcliout
    assert qcliout.exist?
  end
end
