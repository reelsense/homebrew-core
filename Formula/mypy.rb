class Mypy < Formula
  desc "Experimental optional static type checker for Python"
  homepage "http://www.mypy-lang.org/"
  url "https://github.com/python/mypy.git",
      :tag => "v0.511",
      :revision => "88e8ef28be2465d1693ace4d39cd422987a97220"
  head "https://github.com/python/mypy.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "09bd1e807e2095fb02adfabffd82b88b521fc1eec155702732e126184e996f8b" => :sierra
    sha256 "4c1707b6d1344b163d95e598e0a59ad4d7ff8a402603db764230413b8d2665f6" => :el_capitan
    sha256 "40ed3711809aa1680ed479b44e22eafc29b123114549dd72c1ca8b60ce0a9e53" => :yosemite
  end

  option "without-sphinx-doc", "Don't build documentation"

  deprecated_option "without-docs" => "without-sphinx-doc"

  depends_on :python3
  depends_on "sphinx-doc" => [:build, :recommended]

  resource "sphinx_rtd_theme" do
    url "https://files.pythonhosted.org/packages/8b/e5/b1933472424b30affb0a8cea8f0ef052a31ada96e5d1823911d7f4bfdf8e/sphinx_rtd_theme-0.2.4.tar.gz"
    sha256 "2df74b8ff6fae6965c527e97cca6c6c944886aae474b490e17f92adfbe843417"
  end

  resource "typed-ast" do
    url "https://files.pythonhosted.org/packages/89/3d/9684616ba2b69ed73cc51396d777544e8379806fce1d60731b2237c3063c/typed-ast-1.0.3.tar.gz"
    sha256 "67184179697ea9128fa8fec1d3b4e26b41d6a2eceab4674c6e3da4b024309862"
  end

  def install
    xy = Language::Python.major_minor_version "python3"

    if build.with? "sphinx-doc"
      # https://github.com/python/mypy/issues/2593
      version_static = buildpath/"mypy/version_static.py"
      version_static.write "__version__ = '#{version}'\n"
      inreplace "docs/source/conf.py", "mypy.version", "mypy.version_static"

      (buildpath/"docs/sphinx_rtd_theme").install resource("sphinx_rtd_theme")
      # Inject sphinx_rtd_theme's path into sys.path
      inreplace "docs/source/conf.py",
                "sys.path.insert(0, os.path.abspath('../..'))",
                "sys.path[:0] = [os.path.abspath('../..'), os.path.abspath('../sphinx_rtd_theme')]"
      system "make", "-C", "docs", "html"
      doc.install Dir["docs/build/html/*"]

      rm version_static
    end

    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python#{xy}/site-packages"
    resources.each do |r|
      r.stage do
        system "python3", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python#{xy}/site-packages"
    system "python3", *Language::Python.setup_install_args(libexec)

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    xy = Language::Python.major_minor_version "python3"
    ENV["PYTHONPATH"] = libexec/"lib/python#{xy}/site-packages"

    (testpath/"broken.py").write <<-EOS.undent
      def p() -> None:
        print ('hello')
      a = p()
    EOS

    output = pipe_output("#{bin}/mypy #{testpath}/broken.py 2>&1")
    assert_match "\"p\" does not return a value", output
    system "python3", "-c", "import typing"
  end
end
