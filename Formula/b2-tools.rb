class B2Tools < Formula
  include Language::Python::Virtualenv

  desc "B2 Cloud Storage Command-Line Tools"
  homepage "https://github.com/Backblaze/B2_Command_Line_Tool"
  url "https://github.com/Backblaze/B2_Command_Line_Tool/archive/v0.6.8.tar.gz"
  sha256 "ccfb22b0203a27ed170bd65f3dfd655c963b6838d0b3569efb78ea8ec8e79a9f"

  bottle do
    cellar :any_skip_relocation
    sha256 "4cc12ce92c4395e0eaad7a5838d0e751ba032bc13b2798590208016b421cb34f" => :sierra
    sha256 "32ecef3456e90b5aa3c178d32a959290190df17260d8a0babe36f31693307fe5" => :el_capitan
    sha256 "2dcb48ec7e164ed72fed8f53f7437118c60320c74898981b1a6e2397bd6e1dc9" => :yosemite
  end

  depends_on :python if MacOS.version <= :snow_leopard

  conflicts_with "boost-build", :because => "both install `b2` binaries"

  resource "funcsigs" do
    url "https://files.pythonhosted.org/packages/94/4a/db842e7a0545de1cdb0439bb80e6e42dfe82aaeaadd4072f2263a4fbed23/funcsigs-1.0.2.tar.gz"
    sha256 "a7bb0f2cf3a3fd1ab2732cb49eba4252c2af4240442415b4abce3b87022a8f50"
  end

  resource "fury" do
    url "https://github.com/ppolewicz/logfury/archive/0.1.2.tar.gz"
    sha256 "07464a8c1673a6012fee0e7b70b9b12941ede4210ed53e8dcda40433e2ef70fa"
  end

  resource "futures" do
    url "https://files.pythonhosted.org/packages/55/db/97c1ca37edab586a1ae03d6892b6633d8eaa23b23ac40c7e5bbc55423c78/futures-3.0.5.tar.gz"
    sha256 "0542525145d5afc984c88f914a0c85c77527f65946617edb5274f72406f981df"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/2e/ad/e627446492cc374c284e82381215dcd9a0a87c4f6e90e9789afefe6da0ad/requests-2.11.1.tar.gz"
    sha256 "5acf980358283faba0b897c73959cecf8b841205bb4b2ad3ef545f46eae1a133"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/b3/b2/238e2590826bfdd113244a40d9d3eb26918bd798fc187e2360a8367068db/six-1.10.0.tar.gz"
    sha256 "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/12/f6/2d7be1c049d3e1556a43825728b51600ccb54be5ee1f5b2b0cc27887112b/tqdm-4.8.4.tar.gz"
    sha256 "bab05f8bb6efd2702ab6c532e5e6a758a66c0d2f443e09784b73e4066e6b3a37"
  end

  resource "nose" do
    url "https://files.pythonhosted.org/packages/58/a5/0dc93c3ec33f4e281849523a5a913fa1eea9a3068acfa754d44d88107a44/nose-1.3.7.tar.gz"
    sha256 "f1bffef9cbc82628f6e7d7b40d7e255aefaa1adb6a1b1d26c69a8b79e6208a98"
  end

  def install
    virtualenv_install_with_resources
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    system "python", "setup.py", "nosetests"
    bash_completion.install "contrib/bash_completion/b2" => "b2-tools-completion.bash"
  end

  test do
    cmd = "#{bin}/b2 authorize_account BOGUSACCTID BOGUSAPPKEY 2>&1"
    assert_match "bad_auth_token", shell_output(cmd, 1)
  end
end
