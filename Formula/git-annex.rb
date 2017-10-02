require "language/haskell"

class GitAnnex < Formula
  include Language::Haskell::Cabal

  desc "Manage files with git without checking in file contents"
  homepage "https://git-annex.branchable.com/"
  revision 1
  head "git://git-annex.branchable.com/"

  stable do
    url "https://hackage.haskell.org/package/git-annex-6.20170925/git-annex-6.20170925.tar.gz"
    sha256 "c0b14db55a215fdc19f129646ad6a014da99cda5a77af5ce3915e2af6cb3f84f"

    # Upstream commit from 29 Sep 2017 "Fix reversion that made it only run
    # inside a git repository."
    resource "patch-git-annex-test" do
      url "http://source.git-annex.branchable.com/?p=source.git;a=patch;h=f84e34883cfb5b45a86f6c69961886c0ec8843c1"
      sha256 "8291d269e44fce7437016db8e6cf2d27d710aae9b6bcdec28dc11600655f6359"
    end

    # Upstream commit from 29 Sep 2017 "fix process and FD leak" when building
    # with GHC 8.2.1
    resource "patch-fd-leak" do
      url "http://source.git-annex.branchable.com/?p=source.git;a=patch;h=5c32196a376cdaf231a9ccde9bb97297f651a132"
      sha256 "57f26b21efac6d07fa5af96333acfa5a1cdf18cc316c97c0567cacb7d7e0e473"
    end
  end

  bottle do
    sha256 "9966e52d74a73990d171d2f7076ce5930e7157bf40651a9d55ca6c973c710187" => :high_sierra
    sha256 "6cc64794d694cfe863067c8474d87622dbbb60bc98c008cc7ac60a9afa3fa6c8" => :sierra
    sha256 "fb6e67c49ec2572d44d59e7993a7d394d028321770ecaccbbc89a42f6e34268d" => :el_capitan
  end

  option "with-git-union-merge", "Build the git-union-merge tool"

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "pkg-config" => :build
  depends_on "gsasl"
  depends_on "libmagic"
  depends_on "quvi"
  depends_on "xdot" => :recommended

  def install
    if build.stable?
      buildpath.install resource("patch-git-annex-test")
      puts Utils.popen_read("patch", "-f", "-p1", "-i",
           "p=source.git;a=patch;h=f84e34883cfb5b45a86f6c69961886c0ec8843c1")

      buildpath.install resource("patch-fd-leak")
      puts Utils.popen_read("patch", "-f", "-p1", "-i",
           "p=source.git;a=patch;h=5c32196a376cdaf231a9ccde9bb97297f651a132")
    end

    # Upstream issue from 7 Sep 2017 "Please support ghc-8.2.1 (by allowing
    # time-1.8.*)" https://github.com/aristidb/aws/issues/238
    install_cabal_package "--allow-newer=aws:time",
                          :using => ["alex", "happy", "c2hs"], :flags => ["s3", "webapp"] do
      # this can be made the default behavior again once git-union-merge builds properly when bottling
      if build.with? "git-union-merge"
        system "make", "git-union-merge", "PREFIX=#{prefix}"
        bin.install "git-union-merge"
        system "make", "git-union-merge.1", "PREFIX=#{prefix}"
      end
    end
    bin.install_symlink "git-annex" => "git-annex-shell"
  end

  test do
    # make sure git can find git-annex
    ENV.prepend_path "PATH", bin
    # We don't want this here or it gets "caught" by git-annex.
    rm_r "Library/Python/2.7/lib/python/site-packages/homebrew.pth"

    system "git", "init"
    system "git", "annex", "init"
    (testpath/"Hello.txt").write "Hello!"
    assert !File.symlink?("Hello.txt")
    assert_match "add Hello.txt ok", shell_output("git annex add .")
    system "git", "commit", "-a", "-m", "Initial Commit"
    assert File.symlink?("Hello.txt")

    # The steps below are necessary to ensure the directory cleanly deletes.
    # git-annex guards files in a way that isn't entirely friendly of automatically
    # wiping temporary directories in the way `brew test` does at end of execution.
    system "git", "rm", "Hello.txt", "-f"
    system "git", "commit", "-a", "-m", "Farewell!"
    system "git", "annex", "unused"
    assert_match "dropunused 1 ok", shell_output("git annex dropunused 1 --force")
    system "git", "annex", "uninit"
  end
end
