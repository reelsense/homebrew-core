require "language/go"

class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https://github.com/bitrise-io/bitrise"
  url "https://github.com/bitrise-io/bitrise/archive/1.3.3.tar.gz"
  sha256 "a825a412e8ddab4623b3dfcf079e8e70fd32a16d2722ed0bf2b762aad8a4e5f1"

  bottle do
    cellar :any_skip_relocation
    sha256 "c4753b8c913413239d2dbfa762b5bd180df15a7d3ab3ff51fab6caac8d64bfbb" => :el_capitan
    sha256 "01eb63dd511c45a3c56bef14835a6dc5583cd36a77d9345c61b2beaf4ab7560f" => :yosemite
    sha256 "9f0743f000e50a3940178afeca5cf50ba3d086f1bfce3a5ed37ed57f96573d0a" => :mavericks
  end

  depends_on "go" => :build
  depends_on "godep" => :build

  resource "envman" do
    url "https://github.com/bitrise-io/envman/archive/1.1.0.tar.gz"
    sha256 "5e8d92dc8d38050e9e4c037e6d02bf8ad454c74a9a55c1eaeec9df8c691c2a51"
  end

  resource "stepman" do
    url "https://github.com/bitrise-io/stepman/archive/0.9.18.tar.gz"
    sha256 "9aaa9c20d3a73146f32ab280ec2127c6c812cf86fe92467369d7a304fc6563f8"
  end

  def install
    ENV["GOPATH"] = buildpath

    # Install bitrise
    bitrise_go_path = buildpath/"src/github.com/bitrise-io/bitrise"
    bitrise_go_path.install Dir["*"]

    cd bitrise_go_path do
      system "go", "build", "-o", bin/"bitrise"
    end

    # Install envman
    resource("envman").stage do
      envman_go_pth = buildpath/"src/github.com/bitrise-io/envman"
      envman_go_pth.install Dir["*"]

      cd envman_go_pth do
        system "godep", "go", "build", "-o", bin/"envman"
      end
    end

    # Install stepman
    resource("stepman").stage do
      stepman_go_pth = buildpath/"src/github.com/bitrise-io/stepman"
      stepman_go_pth.install Dir["*"]

      cd stepman_go_pth do
        system "godep", "go", "build", "-o", bin/"stepman"
      end
    end
  end

  test do
    (testpath/"bitrise.yml").write <<-EOS.undent
      format_version: 1.1.0
      default_step_lib_source: https://github.com/bitrise-io/bitrise-steplib.git
      workflows:
        test_wf:
          steps:
          - script:
              inputs:
              - content: printf 'Test - OK' > brew.test.file
    EOS

    # setup with --minimal flag, to skip the included `brew doctor` check
    system "#{bin}/bitrise", "setup", "--minimal"
    # run the defined test_wf workflow
    system "#{bin}/bitrise", "run", "test_wf"
    assert_equal "Test - OK", (testpath/"brew.test.file").read.chomp
  end
end
