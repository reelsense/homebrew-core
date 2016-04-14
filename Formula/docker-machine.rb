require "language/go"

class DockerMachine < Formula
  desc "Create Docker hosts locally and on cloud providers"
  homepage "https://docs.docker.com/machine"
  url "https://github.com/docker/machine.git",
    :tag => "v0.7.0",
    :revision => "a650a404fc3e006fea17b12615266168db79c776"

  head "https://github.com/docker/machine.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "86d9ec6859f7fde204cb91dae32156ecaef8a2212d30d259ec28277404e6b673" => :el_capitan
    sha256 "aa181f63f646a447fb68f0d6961a5baf7a136354d59918da63701cbaf10ed2de" => :yosemite
    sha256 "eeffcd5720a79489fb93dba2fa7f1e8bc7f4b1824f51dae885c10833a9dca33c" => :mavericks
  end

  depends_on "go" => :build
  depends_on "automake" => :build

  def install
    ENV["GOBIN"] = bin
    ENV["GOPATH"] = buildpath
    ENV["GOHOME"] = buildpath

    path = buildpath/"src/github.com/docker/machine"
    path.install Dir["*"]

    Language::Go.stage_deps resources, buildpath/"src"

    cd path do
      system "make", "build"
      bin.install Dir["bin/*"]
      bash_completion.install Dir["contrib/completion/bash/*.bash"]
    end
  end

  test do
    assert_match /#{version}/, shell_output(bin/"docker-machine --version")
  end
end
