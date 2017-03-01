class GoAT17 < Formula
  desc "Go programming environment (1.7)"
  homepage "https://golang.org"
  url "https://storage.googleapis.com/golang/go1.7.5.src.tar.gz"
  mirror "https://fossies.org/linux/misc/go1.7.5.src.tar.gz"
  version "1.7.5"
  sha256 "4e834513a2079f8cbbd357502cccaac9507fd00a1efe672375798858ff291815"

  bottle do
    sha256 "d3f5087ea127087bce5fd9e12db25244bc2d9db15f3fc5cb1c1f02118ffcf2f2" => :sierra
    sha256 "cf8b776133c5419823d21819f7752dd8ebcf1596e24af4e9d97495a5d15dc2d0" => :el_capitan
    sha256 "5d1cdb5ca53622c381794cad267d09a65d858bf8f5b1782cd7b837505df22413" => :yosemite
  end

  keg_only :versioned_formula

  option "without-cgo", "Build without cgo (also disables race detector)"
  option "without-godoc", "godoc will not be installed for you"
  option "without-race", "Build without race detector"

  resource "gotools" do
    url "https://go.googlesource.com/tools.git",
        :branch => "release-branch.go1.7"
  end

  depends_on :macos => :mountain_lion

  resource "gobootstrap" do
    url "https://storage.googleapis.com/golang/go1.4-bootstrap-20161024.tar.gz"
    sha256 "398c70d9d10541ba9352974cc585c43220b6d8dbcd804ba2c9bd2fbf35fab286"
  end

  def install
    # GOROOT_FINAL must be overidden later on real Go install
    ENV["GOROOT_FINAL"] = buildpath/"gobootstrap"

    # build the gobootstrap toolchain Go >=1.4
    (buildpath/"gobootstrap").install resource("gobootstrap")
    cd "#{buildpath}/gobootstrap/src" do
      system "./make.bash", "--no-clean"
    end

    # This should happen after we build the test Go, just in case
    # the bootstrap toolchain is aware of this variable too.
    ENV["GOROOT_BOOTSTRAP"] = ENV["GOROOT_FINAL"]
    cd "src" do
      ENV["GOROOT_FINAL"] = libexec
      ENV["GOOS"]         = "darwin"
      ENV["CGO_ENABLED"]  = "0" if build.without?("cgo")
      system "./make.bash", "--no-clean"
    end

    (buildpath/"pkg/obj").rmtree
    rm_rf "gobootstrap" # Bootstrap not required beyond compile.
    libexec.install Dir["*"]
    bin.install_symlink Dir["#{libexec}/bin/go*"]

    # Race detector only supported on amd64 platforms.
    # https://golang.org/doc/articles/race_detector.html
    if build.with?("cgo") && build.with?("race") && MacOS.prefer_64_bit?
      system "#{bin}/go", "install", "-race", "std"
    end

    if build.with?("godoc")
      ENV.prepend_path "PATH", bin
      ENV["GOPATH"] = buildpath
      (buildpath/"src/golang.org/x/tools").install resource("gotools")

      if build.with? "godoc"
        cd "src/golang.org/x/tools/cmd/godoc/" do
          system "go", "build"
          (libexec/"bin").install "godoc"
        end
        bin.install_symlink libexec/"bin/godoc"
      end
    end
  end

  def caveats; <<-EOS.undent
    As of go 1.2, a valid GOPATH is required to use the `go get` command:
      https://golang.org/doc/code.html#GOPATH

    You may wish to add the GOROOT-based install location to your PATH:
      export PATH=$PATH:#{opt_libexec}/bin
    EOS
  end

  test do
    (testpath/"hello.go").write <<-EOS.undent
    package main
    import "fmt"
    func main() {
        fmt.Println("Hello World")
    }
    EOS

    # Run go fmt check for no errors then run the program.
    # This is a a bare minimum of go working as it uses fmt, build, and run.
    system "#{bin}/go", "fmt", "hello.go"
    assert_equal "Hello World\n", shell_output("#{bin}/go run hello.go")

    if build.with? "godoc"
      assert File.exist?(libexec/"bin/godoc")
      assert File.executable?(libexec/"bin/godoc")
    end

    if build.with? "cgo"
      ENV["GOOS"] = "freebsd"
      system bin/"go", "build", "hello.go"
    end
  end
end
