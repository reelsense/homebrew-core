class Szl < Formula
  desc "Compiler and runtime for the Sawzall language"
  homepage "https://code.google.com/archive/p/szl/"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/szl/szl-1.0.tar.gz"
  sha256 "af5c647276fd0dea658eae6016957b7ad09ac68efe13ae2a3c867043b5889f87"
  revision 10

  bottle do
    cellar :any
    sha256 "0a1c3906f2910c460a6c045484f8fbd58182fa54fdd236f6a1552018db636dca" => :sierra
    sha256 "d2f23fd25e8c67639e79753ea23932811628dbe91714238f67ffe058b8ddd84c" => :el_capitan
    sha256 "bb7ad0b1e49fc0eaad48518f12bf984bdcabdfc52afd4e1c9e8791992dc74ca0" => :yosemite
  end

  depends_on :macos => :mavericks

  depends_on "binutils" # For objdump
  depends_on "icu4c"
  depends_on "protobuf"
  depends_on "pcre"
  depends_on "openssl"

  # 10.9 and clang fixes
  # Include reported upstream in:
  # https://code.google.com/archive/p/szl/issues/detail?id=28
  # Clang issue reported upstream in:
  # https://code.google.com/archive/p/szl/issues/detail?id=34
  patch :DATA

  def install
    ENV["OBJDUMP"] = "#{HOMEBREW_PREFIX}/bin/gobjdump"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"szl", "-V"
  end
end

__END__
diff --git a/src/utilities/random_base.cc b/src/utilities/random_base.cc
index 1d64521..e488321 100644
--- a/src/utilities/random_base.cc
+++ b/src/utilities/random_base.cc
@@ -18,6 +18,7 @@
 #include <string>
 #include <memory.h>
 #include <assert.h>
+#include <unistd.h>

 #include "public/porting.h"
 #include "public/logging.h"
diff --git a/src/engine/code.cc b/src/engine/code.cc
index d149f9a..75ab84b 100644
--- a/src/engine/code.cc
+++ b/src/engine/code.cc
@@ -18,6 +18,7 @@
 #include <string>
 #include <errno.h>
 #include <sys/mman.h>
+#include <unistd.h>

 #include "engine/globals.h"
 #include "public/logging.h"
diff --git a/src/engine/symboltable.cc b/src/engine/symboltable.cc
index 6d84592..71965f3 100644
--- a/src/engine/symboltable.cc
+++ b/src/engine/symboltable.cc
@@ -44,7 +44,7 @@ namespace sawzall {
 // ------------------------------------------------------------------------------
 // Implementation of SymbolTable

-Proc::Proc* SymbolTable::init_proc_ = NULL;
+Proc* SymbolTable::init_proc_ = NULL;

 List<TableType*>* SymbolTable::table_types_ = NULL;
 TableType* SymbolTable::collection_type_ = NULL;
