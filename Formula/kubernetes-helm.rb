class KubernetesHelm < Formula
  desc "The Kubernetes package manager"
  homepage "https://helm.sh/"
  url "https://github.com/kubernetes/helm.git",
      :tag => "v2.2.0",
      :revision => "fc315ab59850ddd1b9b4959c89ef008fef5cdf89"
  head "https://github.com/kubernetes/helm.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5c3589aa7825873103f58c18fc5c9a5e26c4bad0cdf6dd4838df39f78d2b88df" => :sierra
    sha256 "70255393999ecadbec883e0b5bc61ae996384891e3fa38c768f900d469ed648e" => :el_capitan
    sha256 "34a7f881df04ca4058d5fb34724d94f122d25789ede4b9b469f3ad2a96c0f27f" => :yosemite
  end

  depends_on :hg => :build
  depends_on "go" => :build
  depends_on "glide" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GLIDE_HOME"] = HOMEBREW_CACHE/"glide_home/#{name}"
    ENV.prepend_create_path "PATH", buildpath/"bin"
    arch = MacOS.prefer_64_bit? ? "amd64" : "x86"
    ENV["TARGETS"] = "darwin/#{arch}"
    dir = buildpath/"src/k8s.io/helm"
    dir.install buildpath.children - [buildpath/".brew_home"]

    cd dir do
      # Set git config to follow redirects
      # Change in behavior in git: https://github.com/git/git/commit/50d3413740d1da599cdc0106e6e916741394cc98
      # Upstream issue: https://github.com/niemeyer/gopkg/issues/50
      system "git", "config", "--global", "http.https://gopkg.in.followRedirects", "true"

      # Bootstap build
      system "make", "bootstrap"

      # Make binary
      system "make", "build"
      bin.install "bin/helm"

      # Install bash completion
      bash_completion.install "scripts/completions.bash" => "helm"
    end
  end

  test do
    system "#{bin}/helm", "create", "foo"
    assert File.directory? "#{testpath}/foo/charts"

    version_output = shell_output("#{bin}/helm version --client 2>&1")
    assert_match "GitTreeState:\"clean\"", version_output
  end
end
