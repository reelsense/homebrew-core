class Bazel < Formula
  desc "Google's own build tool"
  homepage "https://www.bazel.io/"
  head "https://github.com/bazelbuild/bazel.git"

  stable do
    url "https://github.com/bazelbuild/bazel/archive/0.3.1.tar.gz"
    sha256 "52beafc9d78fc315115226f31425e21df1714d96c7dfcdeeb02306e2fe028dd8"

    # Fix build on macOS 10.12 Sierra
    patch do
      url "https://github.com/bazelbuild/bazel/commit/fefd2329f4812bcb513294fdf417fc726a86ddfd.diff"
      sha256 "73455ede4acb9e40923838cb66750a5baacc6b6f8eaaeed72df02dbca38bbe73"
    end
  end

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "8c28efdb500103fc2fe69f5d32b2b433e00345c55c5003cdc53f76e9aec3a22e" => :sierra
    sha256 "9baa84e3f84d5060d39166ff682f7280e93dd173713b83dd5c95c23dda78c942" => :el_capitan
    sha256 "526bcf3e24b646c1f1648d47868654a16e8f566dcf1575034b039f7e17aa91d4" => :yosemite
  end

  depends_on :java => "1.8+"
  depends_on :macos => :yosemite

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
