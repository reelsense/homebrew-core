class Awscli < Formula
  desc "Official Amazon AWS command-line interface"
  homepage "https://aws.amazon.com/cli/"
  url "https://pypi.python.org/packages/c6/89/c238bda4e5e51f2972fd331acaec03b58c75cb27b6ecbc4d535bb88e3e32/awscli-1.10.24.tar.gz"
  mirror "https://github.com/aws/aws-cli/archive/1.10.24.tar.gz"
  sha256 "6afd7a77c4116a7903a462fa5db73dd1086f414c89bfcee85e60d5a94338da60"

  bottle do
    cellar :any_skip_relocation
    sha256 "96d34b7dbc42088574544385c97c3bbf6dfee0d919173e4426450d57723b3ac2" => :el_capitan
    sha256 "32bfe5f2710f40d68c4070a7fec544382340db1aed1fb23218ed350fbd02ed0f" => :yosemite
    sha256 "f08658a2988e0610378ee8c9cbbca78bf3fb3e3233a542a4be3266d623dd0976" => :mavericks
  end

  head do
    url "https://github.com/aws/aws-cli.git", :branch => "develop"

    resource "botocore" do
      url "https://github.com/boto/botocore.git", :branch => "develop"
    end

    resource "jmespath" do
      url "https://github.com/boto/jmespath.git", :branch => "develop"
    end

    resource "s3transfer" do
      url "https://github.com/boto/s3transfer.git", :branch => "develop"
    end
  end

  # Use :python on Lion to avoid urllib3 warning
  # https://github.com/Homebrew/homebrew/pull/37240
  depends_on :python if MacOS.version <= :lion

  resource "six" do
    url "https://pypi.python.org/packages/source/s/six/six-1.10.0.tar.gz"
    sha256 "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a"
  end

  resource "python-dateutil" do
    url "https://pypi.python.org/packages/source/p/python-dateutil/python-dateutil-2.4.2.tar.gz"
    sha256 "3e95445c1db500a344079a47b171c45ef18f57d188dffdb0e4165c71bea8eb3d"
  end

  resource "colorama" do
    url "https://pypi.python.org/packages/source/c/colorama/colorama-0.3.3.tar.gz"
    sha256 "eb21f2ba718fbf357afdfdf6f641ab393901c7ca8d9f37edd0bee4806ffa269c"
  end

  resource "botocore" do
    url "https://pypi.python.org/packages/25/0d/ab3b096247630117feb8e3db628a22045a0496022fcd5ffbc23bee70ecd1/botocore-1.4.15.tar.gz"
    sha256 "3e3affdea68431fbfb4d83ecf7e1e49a9dd5fe31d6818c9ed7bf06ee3279a58c"
  end

  resource "jmespath" do
    url "https://pypi.python.org/packages/source/j/jmespath/jmespath-0.9.0.tar.gz"
    sha256 "08dfaa06d4397f283a01e57089f3360e3b52b5b9da91a70e1fd91e9f0cdd3d3d"
  end

  resource "s3transfer" do
    url "https://pypi.python.org/packages/source/s/s3transfer/s3transfer-0.0.1.tar.gz"
    sha256 "2bb9ed8db58af94dfa78f75f554d646dfe4b4741fc87f63a20c2bfb3f70f4355"
  end

  resource "futures" do
    url "https://pypi.python.org/packages/source/f/futures/futures-3.0.5.tar.gz"
    sha256 "0542525145d5afc984c88f914a0c85c77527f65946617edb5274f72406f981df"
  end

  resource "docutils" do
    url "https://pypi.python.org/packages/source/d/docutils/docutils-0.12.tar.gz"
    sha256 "c7db717810ab6965f66c8cf0398a98c9d8df982da39b4cd7f162911eb89596fa"
  end

  resource "pyasn1" do
    url "https://pypi.python.org/packages/source/p/pyasn1/pyasn1-0.1.9.tar.gz"
    sha256 "853cacd96d1f701ddd67aa03ecc05f51890135b7262e922710112f12a2ed2a7f"
  end

  resource "rsa" do
    url "https://pypi.python.org/packages/source/r/rsa/rsa-3.3.tar.gz"
    sha256 "03f3d9bebad06681771016b8752a40b12f615ff32363c7aa19b3798e73ccd615"
  end

  resource "tox" do
    url "https://pypi.python.org/packages/source/t/tox/tox-2.3.1.tar.gz"
    sha256 "bf7fcc140863820700d3ccd65b33820ba747b61c5fe4e2b91bb8c64cb21a47ee"
  end

  def install
    ENV["PYTHONPATH"] = libexec/"lib/python2.7/site-packages"
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"

    resources.each do |r|
      r.stage do
        system "python", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    system "python", *Language::Python.setup_install_args(libexec)

    # Install zsh completion
    zsh_completion.install "bin/aws_zsh_completer.sh" => "_aws"

    # Install the examples
    pkgshare.install "awscli/examples"

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec+"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  def caveats; <<-EOS.undent
    The "examples" directory has been installed to:
      #{HOMEBREW_PREFIX}/share/awscli/examples

    Add the following to ~/.bashrc to enable bash completion:
      complete -C aws_completer aws

    Add the following to ~/.zshrc to enable zsh completion:
      source #{HOMEBREW_PREFIX}/share/zsh/site-functions/_aws

    Before using awscli, you need to tell it about your AWS credentials.
    The easiest way to do this is to run:
      aws configure

    More information:
      https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-started.html
    EOS
  end

  test do
    system "#{bin}/aws", "--version"
  end
end
