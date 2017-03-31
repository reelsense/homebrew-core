class GithubRelease < Formula
  desc "Create and edit releases on Github (and upload artifacts)"
  homepage "https://github.com/aktau/github-release"
  url "https://github.com/aktau/github-release/archive/v0.7.1.tar.gz"
  sha256 "e7106eac8787f6c2117ab204600b2161ef8102e9563e9fa047167a658c651087"
  head "https://github.com/aktau/github-release.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f76718f748a875c155619516d5bcfcfa2e09a3cd06def26f74323c2697c30d5c" => :sierra
    sha256 "bfcbf4eb54a4a8e598d9a5564a19f889118e25ec7f23a710ce2c481ae9bf28a7" => :el_capitan
    sha256 "c7904277b90e89cdb724f8dad6f6e827ae8e2cb4310738440667c0823d7436b1" => :yosemite
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    system "make"
    bin.install "github-release"
  end

  test do
    system "#{bin}/github-release", "info", "--user", "aktau",
                                            "--repo", "github-release",
                                            "--tag", "v#{version}"
  end
end
