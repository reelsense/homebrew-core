class Logtalk < Formula
  desc "Object-oriented logic programming language"
  homepage "http://logtalk.org"
  url "https://github.com/LogtalkDotOrg/logtalk3/archive/lgt3042stable.tar.gz"
  version "3.04.2"
  sha256 "f8c80741a5ec775cbf846fcb70bf93e8ef6e271d5881c5d0d094451671a64cc8"

  bottle do
    cellar :any_skip_relocation
    sha256 "6ca6246f2b08bbc988d1d8417d82c40dc799620ebec6678be71b2376049c7db2" => :el_capitan
    sha256 "6657b8b860e775b5ade7872dfa081afd53e12a64d8ee8414b7d8f446e283e852" => :yosemite
    sha256 "f7697a5b1c773c9245e99fe3224ed6adb03a7c8f3bfdd4fcb373e2bc3088b62e" => :mavericks
  end

  option "with-swi-prolog", "Build using SWI Prolog as backend"
  option "with-gnu-prolog", "Build using GNU Prolog as backend (Default)"

  deprecated_option "swi-prolog" => "with-swi-prolog"
  deprecated_option "gnu-prolog" => "with-gnu-prolog"

  if build.with? "swi-prolog"
    depends_on "swi-prolog"
  else
    depends_on "gnu-prolog"
  end

  def install
    cd("scripts") { system "./install.sh", "-p", prefix }
  end
end
