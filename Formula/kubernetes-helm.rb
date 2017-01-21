class KubernetesHelm < Formula
  desc "The Kubernetes package manager"
  homepage "https://helm.sh/"
  url "https://github.com/kubernetes/helm.git",
      :tag => "v2.1.3",
      :revision => "5cbc48fb305ca4bf68c26eb8d2a7eb363227e973"
  revision 1
  head "https://github.com/kubernetes/helm.git"

  bottle do
    sha256 "9f4d03a9c0ad97c8e8643a45be8e000622b301fe593b1cf10207876abf4dd848" => :sierra
    sha256 "4955344752ec133296ad476f2a414b7164ddde25119cf9273f1634afefd41b24" => :el_capitan
    sha256 "f75a767b9b8d4c5a47281f1f8eaeb5ce81101939da1132d32f1c37387f448ada" => :yosemite
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
