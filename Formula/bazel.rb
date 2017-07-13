class Bazel < Formula
  desc "Google's own build tool"
  homepage "https://bazel.build/"
  url "https://github.com/bazelbuild/bazel/releases/download/0.5.2/bazel-0.5.2-dist.zip"
  sha256 "2418c619bdd44257a170b85b9d2ecb75def29e751b725e27186468ada2e009ea"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "c102f7c97f48397e2cd128b111f4d1d84698299554c20e5228b0f5526f9d095f" => :sierra
    sha256 "c9d8c15c0105d78b35ce4d405ca7649562aef7bc108ae62d03282ada358ec655" => :el_capitan
    sha256 "a22b2da3456830f057b94ad043f28a511c2d66fd215010745b4fb55d9644b68b" => :yosemite
  end

  depends_on :java => "1.8+"
  depends_on :macos => :yosemite

  # Upstream PR from 27 Jun 2017 "Fix build failure with old OS X mktemp"
  # See https://github.com/bazelbuild/bazel/issues/3279
  patch do
    url "https://github.com/bazelbuild/bazel/pull/3281.patch?full_index=1"
    sha256 "704dff309fa2f6ee5304f72fcbe6d2576326e1bb8e1e41385dc02d773ee35665"
  end

  def install
    ENV["EMBED_LABEL"] = "#{version}-homebrew"
    # Force Bazel ./compile.sh to put its temporary files in the buildpath
    ENV["BAZEL_WRKDIR"] = buildpath/"work"

    system "./compile.sh"
    system "./output/bazel", "--output_user_root", buildpath/"output_user_root",
           "build", "scripts:bash_completion"

    bin.install "scripts/packages/bazel.sh" => "bazel"
    bin.install "output/bazel" => "bazel-real"
    bash_completion.install "bazel-bin/scripts/bazel-complete.bash"
    zsh_completion.install "scripts/zsh_completion/_bazel"
  end

  test do
    touch testpath/"WORKSPACE"

    (testpath/"ProjectRunner.java").write <<-EOS.undent
      public class ProjectRunner {
        public static void main(String args[]) {
          System.out.println("Hi!");
        }
      }
    EOS

    (testpath/"BUILD").write <<-EOS.undent
      java_binary(
        name = "bazel-test",
        srcs = glob(["*.java"]),
        main_class = "ProjectRunner",
      )
    EOS

    system bin/"bazel", "build", "//:bazel-test"
    system "bazel-bin/bazel-test"
  end
end
