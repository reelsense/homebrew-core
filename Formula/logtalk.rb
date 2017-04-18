class Logtalk < Formula
  desc "Object-oriented logic programming language"
  homepage "http://logtalk.org"
  url "https://github.com/LogtalkDotOrg/logtalk3/archive/lgt3105stable.tar.gz"
  version "3.10.5"
  sha256 "6257f6088cdaf0ef399bc962779fbf88e13e7e11d11154ac9dbdcda729990b4b"

  bottle do
    cellar :any_skip_relocation
    sha256 "96f350351cd8eafdb75fd2c47f2aa5bb86b87c2757f52fb732cf6d9719690f97" => :sierra
    sha256 "817c4afc88e330c237c6efa24269064dd616baedbb4b914be3005ebc14333116" => :el_capitan
    sha256 "d24f9c34c2242ca0ba2215a0390cc4df49d2b2120d685cee71d8eca642d196bc" => :yosemite
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
