class UniversalBrewedPython < Requirement
  satisfy { archs_for_command("python").universal? }

  def message; <<-EOS.undent
    A build of GDB using a brewed Python was requested, but Python is not
    a universal build.

    GDB requires Python to be built as a universal binary or it will fail
    if attempting to debug a 32-bit binary on a 64-bit host.
    EOS
  end
end

class Gdb < Formula
  desc "GNU debugger"
  homepage "https://www.gnu.org/software/gdb/"
  url "https://ftpmirror.gnu.org/gdb/gdb-7.12.1.tar.xz"
  mirror "https://ftp.gnu.org/gnu/gdb/gdb-7.12.1.tar.xz"
  sha256 "4607680b973d3ec92c30ad029f1b7dbde3876869e6b3a117d8a7e90081113186"

  bottle do
    sha256 "802fbab9c470ba7efe22337f77e62f64159e64fcac73cfc084885ddc21d1e35d" => :sierra
    sha256 "d4549182907a4c272d2417e9451603d4e32216bc3cfdfd437c77d74b1100158b" => :el_capitan
    sha256 "baccdfcc0c431b4ac4836d5c77866f4b1e1d2c3568e90ff1a6616bac99e2bfbc" => :yosemite
  end

  deprecated_option "with-brewed-python" => "with-python"

  option "with-python", "Use the Homebrew version of Python; by default system Python is used"
  option "with-version-suffix", "Add a version suffix to program"
  option "with-all-targets", "Build with support for all targets"

  depends_on "pkg-config" => :build
  depends_on "python" => :optional
  depends_on "guile" => :optional

  if MacOS.version >= :sierra
    patch do
      # Patch is needed to work on new 10.12 installs with SIP.
      # See http://sourceware-org.1504.n7.nabble.com/gdb-on-macOS-10-12-quot-Sierra-quot-td415708.html
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/9d3dbc2/gdb/0001-darwin-nat.c-handle-Darwin-16-aka-Sierra.patch"
      sha256 "a71489440781ae133eeba5a3123996e55f72bd914dbfdd3af0b0700f6d0e4e08"
    end
  end

  if build.with? "python"
    depends_on UniversalBrewedPython
  end

  def install
    args = [
      "--prefix=#{prefix}",
      "--disable-debug",
      "--disable-dependency-tracking",
    ]

    args << "--with-guile" if build.with? "guile"
    args << "--enable-targets=all" if build.with? "all-targets"

    if build.with? "python"
      args << "--with-python=#{HOMEBREW_PREFIX}"
    else
      args << "--with-python=/usr"
    end

    if build.with? "version-suffix"
      args << "--program-suffix=-#{version.to_s.slice(/^\d/)}"
    end

    system "./configure", *args
    system "make"
    system "make", "install"

    # Remove conflicting items with binutils
    rm_rf include
    rm_rf lib
    rm_rf share/"locale"
    rm_rf share/"info"
  end

  def caveats; <<-EOS.undent
    gdb requires special privileges to access Mach ports.
    You will need to codesign the binary. For instructions, see:

      https://sourceware.org/gdb/wiki/BuildingOnDarwin

    On 10.12 (Sierra) or later with SIP, you need to run this:

      echo "set startup-with-shell off" >> ~/.gdbinit
    EOS
  end

  test do
    system bin/"gdb", bin/"gdb", "-configuration"
  end
end
