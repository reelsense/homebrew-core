require "language/go"

class GitlabCiMultiRunner < Formula
  desc "The official GitLab CI runner written in Go"
  homepage "https://gitlab.com/gitlab-org/gitlab-ci-multi-runner"
  url "https://gitlab.com/gitlab-org/gitlab-ci-multi-runner.git",
      :tag => "v9.4.1",
      :revision => "d24b11c490710da524bef609b003389ebcba9f29"
  head "https://gitlab.com/gitlab-org/gitlab-ci-multi-runner.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "65260a30376b743740901bf21f6cc54ac14d25a6e64cf4f58077e3e60c1ed72c" => :sierra
    sha256 "8dd1f2d2b95c25abd051348fb3defc84db3977c62e87eeaa97ce6cb39f70368f" => :el_capitan
    sha256 "3c90adff877685bb17cd8f9feba26fba7e62db3e455b828f149e410713d97a8e" => :yosemite
  end

  depends_on "go" => :build
  depends_on "docker" => :recommended

  go_resource "github.com/jteeuwen/go-bindata" do
    url "https://github.com/jteeuwen/go-bindata.git",
        :revision => "a0ff2567cfb70903282db057e799fd826784d41d"
  end

  resource "prebuilt-x86_64.tar.xz" do
    url "https://gitlab-ci-multi-runner-downloads.s3.amazonaws.com/v9.4.1/docker/prebuilt-x86_64.tar.xz",
        :using => :nounzip
    version "9.4.1"
    sha256 "01596f0ff33ae6e4106bf8fb15c18641e0d896b979a721234de6102d431feb94"
  end

  resource "prebuilt-arm.tar.xz" do
    url "https://gitlab-ci-multi-runner-downloads.s3.amazonaws.com/v9.4.1/docker/prebuilt-arm.tar.xz",
        :using => :nounzip
    version "9.4.1"
    sha256 "12d2f730aa53cbdce80b87aaa9540b03be05502561cfdc8e4d1db2a1cd0537e0"
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

  plist_options :manual => "gitlab-ci-multi-runner start"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>SessionCreate</key><false/>
        <key>KeepAlive</key><true/>
        <key>RunAtLoad</key><true/>
        <key>Disabled</key><false/>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_bin}/gitlab-ci-multi-runner</string>
          <string>run</string>
          <string>--working-directory</string>
          <string>#{ENV["HOME"]}</string>
          <string>--config</string>
          <string>#{ENV["HOME"]}/.gitlab-runner/config.toml</string>
          <string>--service</string>
          <string>gitlab-runner</string>
          <string>--syslog</string>
        </array>
      </dict>
    </plist>
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gitlab-runner --version")
  end
end
