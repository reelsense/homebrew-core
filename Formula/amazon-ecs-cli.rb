class AmazonEcsCli < Formula
  desc "CLI for Amazon ECS to manage clusters and tasks for development."
  homepage "https://aws.amazon.com/ecs"
  url "https://github.com/aws/amazon-ecs-cli/archive/v0.4.6.tar.gz"
  sha256 "d61c8f09a2a31d160b1676f09ab7360cca9fdc00bc28c24cebbb5a05d5f38319"

  bottle do
    sha256 "f918f92be0799beec43553aafee8f6ff43db70f279996f97256ce488931dfbb8" => :sierra
    sha256 "1a7966b456b4057c92d709b3b4cafdc0ff217b0ea536484686020099390eb896" => :el_capitan
    sha256 "44b77ac11ee46d2dbd4cd160096bc68f650b57e11d2a3fee4dcd753ca911f2d3" => :yosemite
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/aws/amazon-ecs-cli").install buildpath.children
    cd "src/github.com/aws/amazon-ecs-cli" do
      system "make", "build"
      system "make", "test"
      bin.install "bin/local/ecs-cli"
      prefix.install_metafiles
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ecs-cli -v")
  end
end
