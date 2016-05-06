class GstEditingServices < Formula
  desc "GStreamer Editing Services"
  homepage "https://gstreamer.freedesktop.org/modules/gst-editing-services.html"
  url "https://gstreamer.freedesktop.org/src/gst-editing-services/gstreamer-editing-services-1.8.1.tar.xz"
  sha256 "897babc2da242438992a2361a74cde16d3feb5eab56c653a3aeb553f45365020"

  bottle do
    sha256 "f35cc94ab7b1efc5e01d6dcc3e35214d0b9566d0c0c53a6fa21d35d4dd7b741b" => :el_capitan
    sha256 "15bdd23de3560faabb0dcbd407230c4f3826bb3cd27890c1734f21145a0aef1b" => :yosemite
    sha256 "7e3283dbeb687c890b0568ccd2b96845d0c35a480b5db4c92b4af49b03c2edbf" => :mavericks
  end

  depends_on "gstreamer"
  depends_on "gst-plugins-base"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-gtk-doc",
                          "--disable-docbook"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/ges-launch-1.0", "--ges-version"
  end
end
