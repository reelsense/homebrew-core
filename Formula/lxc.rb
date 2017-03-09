require "language/go"

class Lxc < Formula
  desc "CLI client for interacting with LXD"
  homepage "https://linuxcontainers.org"
  url "https://github.com/lxc/lxd/archive/lxd-2.10.tar.gz"
  sha256 "926b50a15523b4e181b0c3503b9accb35b276c27034a295fc56ae45a5dc1a811"

  bottle do
    cellar :any_skip_relocation
    sha256 "8c53a1e50839acf3cc7a0af41e8e9f595b6ae0c1fd6f3fc983937f0fa3159d41" => :sierra
    sha256 "78cbcb41a4f8686bbe0416921cfbe0dc54212b800349f39017b013b38ad6b092" => :el_capitan
    sha256 "ce96cc6ec25733bb61e305baed5884eb77a576c83b6cca8f6d45e3ea714ec8a6" => :yosemite
  end

  depends_on "go" => :build

  go_resource "github.com/dustinkirkland/golang-petname" do
    url "https://github.com/dustinkirkland/golang-petname.git",
        :revision => "242afa0b4f8af1fa581e7ea7f4b6d51735fa3fef"
  end

  go_resource "github.com/golang/protobuf" do
    url "https://github.com/golang/protobuf.git",
        :revision => "8ee79997227bf9b34611aee7946ae64735e6fd93"
  end

  go_resource "github.com/gorilla/mux" do
    url "https://github.com/gorilla/mux.git",
        :revision => "392c28fe23e1c45ddba891b0320b3b5df220beea"
  end

  go_resource "github.com/gorilla/websocket" do
    url "https://github.com/gorilla/websocket.git",
        :revision => "c36f2fe5c330f0ac404b616b96c438b8616b1aaf"
  end

  go_resource "github.com/mattn/go-colorable" do
    url "https://github.com/mattn/go-colorable.git",
        :revision => "d228849504861217f796da67fae4f6e347643f15"
  end

  go_resource "github.com/mattn/go-runewidth" do
    url "https://github.com/mattn/go-runewidth.git",
        :revision => "14207d285c6c197daabb5c9793d63e7af9ab2d50"
  end

  go_resource "github.com/mattn/go-sqlite3" do
    url "https://github.com/mattn/go-sqlite3.git",
        :revision => "ce9149a3c941c30de51a01dbc5bc414ddaa52927"
  end

  go_resource "github.com/olekukonko/tablewriter" do
    url "https://github.com/olekukonko/tablewriter.git",
        :revision => "febf2d34b54a69ce7530036c7503b1c9fbfdf0bb"
  end

  go_resource "github.com/pborman/uuid" do
    url "https://github.com/pborman/uuid.git",
        :revision => "1b00554d822231195d1babd97ff4a781231955c9"
  end

  go_resource "github.com/stretchr/testify" do
    url "https://github.com/stretchr/testify.git",
        :revision => "4d4bfba8f1d1027c4fdbe371823030df51419987"
  end

  go_resource "github.com/syndtr/gocapability" do
    url "https://github.com/syndtr/gocapability.git",
        :revision => "e7cb7fa329f456b3855136a2642b197bad7366ba"
  end

  go_resource "golang.org/x/crypto" do
    url "https://go.googlesource.com/crypto.git",
        :revision => "bed12803fa9663d7aa2c2346b0c634ad2dcd43b7"
  end

  go_resource "golang.org/x/net" do
    url "https://go.googlesource.com/net.git",
        :revision => "41bba8d80bbfab43231ffdf4c210037baae5f6a3"
  end

  go_resource "gopkg.in/flosch/pongo2.v3" do
    url "https://github.com/flosch/pongo2.git",
        :revision => "5e81b817a0c48c1c57cdf1a9056cf76bdee02ca9"
  end

  go_resource "gopkg.in/inconshreveable/log15.v2" do
    url "https://github.com/inconshreveable/log15.git",
        :revision => "b105bd37f74e5d9dc7b6ad7806715c7a2b83fd3f"
  end

  go_resource "gopkg.in/lxc/go-lxc.v2" do
    url "https://github.com/lxc/go-lxc.git",
        :revision => "82a07a67a43089687c0cc71ad515cde8d8ae3b8f"
  end

  go_resource "gopkg.in/tomb.v2" do
    url "https://github.com/go-tomb/tomb.git",
        :revision => "d5d1b5820637886def9eef33e03a27a9f166942c"
  end

  go_resource "gopkg.in/yaml.v2" do
    url "https://github.com/go-yaml/yaml.git",
        :revision => "4c78c975fe7c825c6d1466c42be594d1d6f3aba6"
  end

  def install
    ENV["GOPATH"] = buildpath
    ENV["GOBIN"] = bin

    (buildpath/"src/github.com/lxc/lxd").install buildpath.children
    Language::Go.stage_deps resources, buildpath/"src"

    cd "src/github.com/lxc/lxd" do
      system "go", "install", "-v", "./lxc"
      prefix.install_metafiles
    end
  end

  test do
    system "#{bin}/lxc", "--version"
  end
end
