require "language/node"

class Jhipster < Formula
  desc "Generate, develop and deploy Spring Boot + Angular applications"
  homepage "https://jhipster.github.io/"
  url "https://registry.npmjs.org/generator-jhipster/-/generator-jhipster-4.6.1.tgz"
  sha256 "13e5d0624c8fcdf69ec6bf2c902d481159b4450261e7a314d0a5af6d06e06d16"

  bottle do
    cellar :any_skip_relocation
    sha256 "a5a24d0021ca47ed84db1e74d4cbb9021fe86792d775ab925ed4edae86484a22" => :sierra
    sha256 "5469e72ee21d45f62cff1ccfe5d49f3e8cd9bd1add83ab5d8da9a15cb0159916" => :el_capitan
    sha256 "104d52b575859d3b16a8869e1768b510f604bd97487eff3fff512fcfea5420c7" => :yosemite
  end

  depends_on "node"
  depends_on "yarn"
  depends_on :java => "1.8+"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "Execution complete", shell_output("#{bin}/jhipster info")
  end
end
