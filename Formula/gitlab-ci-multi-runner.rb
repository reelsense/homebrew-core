require "language/go"

class GitlabCiMultiRunner < Formula
  desc "The official GitLab CI runner written in Go"
  homepage "https://gitlab.com/gitlab-org/gitlab-ci-multi-runner"
  url "https://gitlab.com/gitlab-org/gitlab-ci-multi-runner.git",
      :tag => "v1.9.2",
      :revision => "ade6572ddb2d1e75243c31333fb392ac2a745685"
  head "https://gitlab.com/gitlab-org/gitlab-ci-multi-runner.git"

  bottle do
    sha256 "c1fa1fa50efafe1378636cb488c842455fcf3418ede755c5170b517870b58b93" => :sierra
    sha256 "a3123cda5d9d0c09b028e8cb6ebe3b4473b9ed2dc2c019d9c9079a1bb87a4eb6" => :el_capitan
    sha256 "7e1b5487beffd8105b6d597f2058f8bfd802246ab92e17a476f2b547d796cb3b" => :yosemite
  end

  depends_on "go" => :build
  depends_on "docker" => :recommended

  go_resource "github.com/jteeuwen/go-bindata" do
    url "https://github.com/jteeuwen/go-bindata.git",
        :revision => "a0ff2567cfb70903282db057e799fd826784d41d"
  end

  resource "prebuilt-x86_64.tar.xz" do
    url "https://gitlab-ci-multi-runner-downloads.s3.amazonaws.com/v1.9.2/docker/prebuilt-x86_64.tar.xz",
        :using => :nounzip
    version "1.9.2"
    sha256 "7d0759dd04f930a231c1a713d8e44a149666112ff1d841c5173847a373496278"
  end

  resource "prebuilt-arm.tar.xz" do
    url "https://gitlab-ci-multi-runner-downloads.s3.amazonaws.com/v1.9.2/docker/prebuilt-arm.tar.xz",
        :using => :nounzip
    version "1.9.2"
    sha256 "c4f7297865fafa4e7841e513a26b334cf9f29ad6d7ec4b12381d6031fa6f9648"
  end

  def install
    ENV["GOPATH"] = buildpath
    dir = buildpath/"src/gitlab.com/gitlab-org/gitlab-ci-multi-runner"
    dir.install buildpath.children
    ENV.prepend_create_path "PATH", buildpath/"bin"
    Language::Go.stage_deps resources, buildpath/"src"

    cd "src/github.com/jteeuwen/go-bindata/go-bindata" do
      system "go", "install"
    end

    cd dir do
      Pathname.pwd.install resource("prebuilt-x86_64.tar.xz"),
                           resource("prebuilt-arm.tar.xz")
      system "go-bindata", "-pkg", "docker", "-nocompress", "-nomemcopy",
                           "-nometadata", "-o",
                           "#{dir}/executors/docker/bindata.go",
                           "prebuilt-x86_64.tar.xz",
                           "prebuilt-arm.tar.xz"

      proj = "gitlab.com/gitlab-org/gitlab-ci-multi-runner"
      commit = Utils.popen_read("git", "rev-parse", "--short", "HEAD").chomp
      branch = version.to_s.split(".")[0..1].join("-") + "-stable"
      built = Time.new.strftime("%Y-%m-%dT%H:%M:%S%:z")
      system "go", "build", "-ldflags", <<-EOS.undent
             -X #{proj}/common.NAME=gitlab-ci-multi-runner
             -X #{proj}/common.VERSION=#{version}
             -X #{proj}/common.REVISION=#{commit}
             -X #{proj}/common.BRANCH=#{branch}
             -X #{proj}/common.BUILT=#{built}
      EOS

      bin.install "gitlab-ci-multi-runner"
      bin.install_symlink bin/"gitlab-ci-multi-runner" => "gitlab-runner"
      prefix.install_metafiles
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gitlab-runner --version")
  end
end
