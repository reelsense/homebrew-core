require "language/haskell"
require "net/http"

class Postgrest < Formula
  include Language::Haskell::Cabal

  desc "Serves a fully RESTful API from any existing PostgreSQL database"
  homepage "https://github.com/begriffs/postgrest"
  url "https://github.com/begriffs/postgrest/archive/v0.3.2.0.tar.gz"
  sha256 "1cedceb22f051d4d80a75e4ac7a875164e3ee15bd6f6edc68dfca7c9265a2481"
  head "https://github.com/begriffs/postgrest.git"
  revision 1

  bottle do
    sha256 "e46e739256e3f753abe8540db32cff90ed8e4adfbed1e658cb229dc8ded0ce00" => :sierra
    sha256 "287da0080c05d3e3903d8c8fcaa18f55811b857d297096664511bfdbc7868caa" => :el_capitan
    sha256 "57351277753e13fd3667c12b1514290f7aaac42abd90e03309ac7a6d04a931b4" => :yosemite
  end

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build
  depends_on "postgresql"

  def install
    install_cabal_package :using => ["happy"]
  end

  test do
    pg_bin  = Formula["postgresql"].bin
    pg_port = 55561
    pg_user = "postgrest_test_user"
    test_db = "test_postgrest_formula"

    system "#{pg_bin}/initdb", "-D", testpath/test_db,
      "--auth=trust", "--username=#{pg_user}"

    system "#{pg_bin}/pg_ctl", "-D", testpath/test_db, "-l",
      testpath/"#{test_db}.log", "-w", "-o", %Q("-p #{pg_port}"), "start"

    begin
      system "#{pg_bin}/createdb", "-w", "-p", pg_port, "-U", pg_user, test_db
      pid = fork do
        exec "postgrest", "postgres://#{pg_user}@localhost:#{pg_port}/#{test_db}",
          "-a", pg_user, "-p", "55560"
      end
      Process.detach(pid)
      sleep(5) # Wait for the server to start
      response = Net::HTTP.get(URI("http://localhost:55560"))
      assert_equal "[]", response
    ensure
      begin
        Process.kill("TERM", pid) if pid
      ensure
        system "#{pg_bin}/pg_ctl", "-D", testpath/test_db, "stop",
          "-s", "-m", "fast"
      end
    end
  end
end
