class Mono < Formula
  desc "Cross platform, open source .NET development framework"
  homepage "http://www.mono-project.com/"
  url "https://download.mono-project.com/sources/mono/mono-4.6.1.5.tar.bz2"
  sha256 "3871ee72bdfc2ea5d636ffff22cf49ae6bac7c4a4f3d687214dd8ac236bbf7c3"

  bottle do
    sha256 "8a28d69e45374c53f375fa2e7fa96aae8f9b8db3ea970d33cb01492e9874e3a9" => :sierra
    sha256 "7065d9c83700493e586f09d71366e64741493102fc6338ab0cea4f8ceddf978f" => :el_capitan
    sha256 "6899f853419e379c059f56ea7fbbb815a349deabced62c83966e9790228b0b96" => :yosemite
  end

  # xbuild requires the .exe files inside the runtime directories to
  # be executable
  skip_clean "lib/mono"

  link_overwrite "bin/fsharpi"
  link_overwrite "bin/fsharpiAnyCpu"
  link_overwrite "bin/fsharpc"
  link_overwrite "bin/fssrgen"
  link_overwrite "lib/mono"
  link_overwrite "lib/cli"

  option "without-fsharp", "Build without support for the F# language."

  depends_on "automake" => :build
  depends_on "autoconf" => :build
  depends_on "pkg-config" => :build

  conflicts_with "xsd", :because => "both install `xsd` binaries"
  conflicts_with "czmq", :because => "both install `makecert` binaries"

  resource "fsharp" do
    url "https://github.com/fsharp/fsharp.git",
        :tag => "4.0.1.13",
        :revision => "4194b3bbb506a18f48e0f7e39e2c3fb0d7c8b566"
  end

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
      --disable-silent-rules
      --enable-nls=no
    ]

    args << "--build=" + (MacOS.prefer_64_bit? ? "x86_64": "i686") + "-apple-darwin"

    system "./configure", *args
    system "make"
    system "make", "install"
    # mono-gdb.py and mono-sgen-gdb.py are meant to be loaded by gdb, not to be
    # run directly, so we move them out of bin
    libexec.install bin/"mono-gdb.py", bin/"mono-sgen-gdb.py"

    # Now build and install fsharp as well
    if build.with? "fsharp"
      resource("fsharp").stage do
        ENV.prepend_path "PATH", bin
        ENV.prepend_path "PKG_CONFIG_PATH", lib/"pkgconfig"
        system "./autogen.sh", "--prefix=#{prefix}"
        system "make"
        system "make", "install"
      end
    end
  end

  def caveats; <<-EOS.undent
    To use the assemblies from other formulae you need to set:
      export MONO_GAC_PREFIX="#{HOMEBREW_PREFIX}"
    Note that the 'mono' formula now includes F#. If you have
    the 'fsharp' formula installed, remove it with 'brew uninstall fsharp'.
    EOS
  end

  test do
    test_str = "Hello Homebrew"
    test_name = "hello.cs"
    (testpath/test_name).write <<-EOS.undent
      public class Hello1
      {
         public static void Main()
         {
            System.Console.WriteLine("#{test_str}");
         }
      }
    EOS
    shell_output("#{bin}/mcs #{test_name}")
    output = shell_output("#{bin}/mono hello.exe")
    assert_match test_str, output.strip

    # Tests that xbuild is able to execute lib/mono/*/mcs.exe
    (testpath/"test.csproj").write <<-EOS.undent
      <?xml version="1.0" encoding="utf-8"?>
      <Project ToolsVersion="4.0" DefaultTargets="Build" xmlns="http://schemas.microsoft.com/developer/msbuild/2003">
        <PropertyGroup>
          <AssemblyName>HomebrewMonoTest</AssemblyName>
          <TargetFrameworkVersion>v4.5</TargetFrameworkVersion>
        </PropertyGroup>
        <ItemGroup>
          <Compile Include="#{test_name}" />
        </ItemGroup>
        <Import Project="$(MSBuildBinPath)\\Microsoft.CSharp.targets" />
      </Project>
    EOS
    system bin/"xbuild", "test.csproj"

    if build.with? "fsharp"
      # Test that fsharpi is working
      ENV.prepend_path "PATH", bin
      output = pipe_output("#{bin}/fsharpi", "printfn \"#{test_str}\"; exit 0")
      assert_match test_str, output

      # Tests that xbuild is able to execute fsc.exe
      (testpath/"test.fsproj").write <<-EOS.undent
        <?xml version="1.0" encoding="utf-8"?>
        <Project ToolsVersion="4.0" DefaultTargets="Build" xmlns="http://schemas.microsoft.com/developer/msbuild/2003">
          <PropertyGroup>
            <ProductVersion>8.0.30703</ProductVersion>
            <SchemaVersion>2.0</SchemaVersion>
            <ProjectGuid>{B6AB4EF3-8F60-41A1-AB0C-851A6DEB169E}</ProjectGuid>
            <OutputType>Exe</OutputType>
            <DefineConstants>TRACE</DefineConstants>
            <FSharpTargetsPath>$(MSBuildExtensionsPath32)\\Microsoft\\VisualStudio\\v$(VisualStudioVersion)\\FSharp\\Microsoft.FSharp.Targets</FSharpTargetsPath>
          </PropertyGroup>
          <Import Project="$(FSharpTargetsPath)" Condition="Exists('$(FSharpTargetsPath)')" />
          <ItemGroup>
            <Compile Include="Main.fs" />
          </ItemGroup>
          <ItemGroup>
            <Reference Include="mscorlib" />
            <Reference Include="System" />
            <Reference Include="FSharp.Core" />
          </ItemGroup>
        </Project>
      EOS
      (testpath/"Main.fs").write <<-EOS.undent
        [<EntryPoint>]
        let main _ = printfn "#{test_str}"; 0
      EOS
      system bin/"xbuild", "test.fsproj"
    end
  end
end
