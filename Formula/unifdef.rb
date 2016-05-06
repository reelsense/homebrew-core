class Unifdef < Formula
  desc "Selectively process conditional C preprocessor directives"
  homepage "http://dotat.at/prog/unifdef/"
  url "http://dotat.at/prog/unifdef/unifdef-2.11.tar.gz"
  sha256 "e8483c05857a10cf2d5e45b9e8af867d95991fab0f9d3d8984840b810e132d98"
  head "https://github.com/fanf2/unifdef.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a89e5cc9b179fa5135077ad0c27e34cebe13a33dc02adccab4969855ba173357" => :el_capitan
    sha256 "3277bf0977c385e3cf5ccf3355e11f30b057c58d8539a27d5a23531ce7de9542" => :yosemite
    sha256 "8533d1ce7b70e51256a3c24d557345b7b7ac0b7e6562de5a0f942c058ae518db" => :mavericks
  end

  keg_only :provided_by_osx,
    "The unifdef provided by Xcode cannot compile gevent."

  def install
    system "make", "prefix=#{prefix}", "install"
  end

  test do
    pipe_output("#{bin}/unifdef", "echo ''")
  end
end
