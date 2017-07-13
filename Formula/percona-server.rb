class PerconaServer < Formula
  desc "Drop-in MySQL replacement"
  homepage "https://www.percona.com"
  url "https://www.percona.com/downloads/Percona-Server-5.7/Percona-Server-5.7.18-15/source/tarball/percona-server-5.7.18-15.tar.gz"
  sha256 "a95d5c79122a889300855483426483975445a247c4b3f9ed2a9a54f4b4cd60bc"

  bottle do
    sha256 "ea235553609cd147d8bd700967c74e4ec2e1ae3eeb595d1c37a7294b31eaf934" => :sierra
    sha256 "3b4486d2a288bee9b8599652ce96498fd5e032d203f270269d6ad27f74ddc706" => :el_capitan
    sha256 "29beb2aa21ea5305837240778a0d0040e5aca9f1549bac6b303c90fcc6d3f33b" => :yosemite
  end

  option "with-test", "Build with unit tests"
  option "with-embedded", "Build the embedded server"
  option "with-local-infile", "Build with local infile loading support"

  deprecated_option "enable-local-infile" => "with-local-infile"
  deprecated_option "with-tests" => "with-test"

  depends_on "cmake" => :build
  depends_on "pidof" unless MacOS.version >= :mountain_lion
  depends_on "openssl"

  conflicts_with "mysql-connector-c",
    :because => "both install `mysql_config`"

  conflicts_with "mariadb", "mysql", "mysql-cluster",
    :because => "percona, mariadb, and mysql install the same binaries."
  conflicts_with "mysql-connector-c",
    :because => "both install MySQL client libraries"
  conflicts_with "mariadb-connector-c",
    :because => "both install plugins"

  resource "boost" do
    url "https://downloads.sourceforge.net/project/boost/boost/1.59.0/boost_1_59_0.tar.bz2"
    sha256 "727a932322d94287b62abb1bd2d41723eec4356a7728909e38adb65ca25241ca"
  end

  # Where the database files should be located. Existing installs have them
  # under var/percona, but going forward they will be under var/mysql to be
  # shared with the mysql and mariadb formulae.
  def datadir
    @datadir ||= (var/"percona").directory? ? var/"percona" : var/"mysql"
  end

  pour_bottle? do
    reason "The bottle needs a var/mysql datadir (yours is var/percona)."
    satisfy { datadir == var/"mysql" }
  end

  def install
    # Don't hard-code the libtool path. See:
    # https://github.com/Homebrew/homebrew/issues/20185
    inreplace "cmake/libutils.cmake",
      "COMMAND /usr/bin/libtool -static -o ${TARGET_LOCATION}",
      "COMMAND libtool -static -o ${TARGET_LOCATION}"

    args = std_cmake_args + %W[
      -DMYSQL_DATADIR=#{datadir}
      -DSYSCONFDIR=#{etc}
      -DINSTALL_MANDIR=#{man}
      -DINSTALL_DOCDIR=#{doc}
      -DINSTALL_INFODIR=#{info}
      -DINSTALL_INCLUDEDIR=include/mysql
      -DINSTALL_MYSQLSHAREDIR=#{share.basename}/mysql
      -DWITH_SSL=yes
      -DDEFAULT_CHARSET=utf8
      -DDEFAULT_COLLATION=utf8_general_ci
      -DCOMPILATION_COMMENT=Homebrew
      -DWITH_EDITLINE=system
    ]

    # PAM plugin is Linux-only at the moment
    args.concat %w[
      -DWITHOUT_AUTH_PAM=1
      -DWITHOUT_AUTH_PAM_COMPAT=1
      -DWITHOUT_DIALOG=1
    ]

    # TokuDB is broken on MacOsX
    # https://bugs.launchpad.net/percona-server/+bug/1531446
    args.concat %w[-DWITHOUT_TOKUDB=1]

    # MySQL >5.7.x mandates Boost as a requirement to build & has a strict
    # version check in place to ensure it only builds against expected release.
    # This is problematic when Boost releases don't align with MySQL releases.
    (buildpath/"boost_1_59_0").install resource("boost")
    args << "-DWITH_BOOST=#{buildpath}/boost_1_59_0"

    # To enable unit testing at build, we need to download the unit testing suite
    if build.with? "test"
      args << "-DENABLE_DOWNLOADS=ON"
    else
      args << "-DWITH_UNIT_TESTS=OFF"
    end

    # Build the embedded server
    args << "-DWITH_EMBEDDED_SERVER=ON" if build.with? "embedded"

    # Build with InnoDB Memcached plugin
    args << "-DWITH_INNODB_MEMCACHED=ON" if build.with? "memcached"

    # Build with local infile loading support
    args << "-DENABLED_LOCAL_INFILE=1" if build.with? "local-infile"

    system "cmake", *args
    system "make"
    system "make", "install"

    # Don't create databases inside of the prefix!
    # See: https://github.com/Homebrew/homebrew/issues/4975
    rm_rf prefix+"data"

    # Fix up the control script and link into bin
    inreplace "#{prefix}/support-files/mysql.server",
              /^(PATH=".*)(")/,
              "\\1:#{HOMEBREW_PREFIX}/bin\\2"
    bin.install_symlink prefix/"support-files/mysql.server"

    # Install my.cnf that binds to 127.0.0.1 by default
    (buildpath/"my.cnf").write <<-EOS.undent
      # Default Homebrew MySQL server config
      [mysqld]
      # Only allow connections from localhost
      bind-address = 127.0.0.1
    EOS
    etc.install "my.cnf"
  end

  def caveats; <<-EOS.undent
    A "/etc/my.cnf" from another install may interfere with a Homebrew-built
    server starting up correctly.

    MySQL is configured to only allow connections from localhost by default

    To connect:
        mysql -uroot

    To initialize the data directory:
        mysqld --initialize --datadir=#{datadir} --user=#{ENV["USER"]}
    EOS
  end

  plist_options :manual => "mysql.server start"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>KeepAlive</key>
      <true/>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>Program</key>
      <string>#{opt_bin}/mysqld_safe</string>
      <key>RunAtLoad</key>
      <true/>
      <key>WorkingDirectory</key>
      <string>#{var}</string>
    </dict>
    </plist>
    EOS
  end

  test do
    begin
      (testpath/"mysql_test.sql").write <<-EOS.undent
        CREATE DATABASE `mysql_test`;
        USE `mysql_test`;
        CREATE TABLE `mysql_test`.`test` (
        `id` BIGINT(21) UNSIGNED NOT NULL AUTO_INCREMENT,
        `name` VARCHAR(127) NOT NULL COMMENT '42',
        PRIMARY KEY (`id`),
        KEY `name` (`name`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;
        INSERT INTO `mysql_test`.`test` VALUES (NULL, '42');
        SELECT * FROM `mysql_test`.`test` WHERE `name` = '42';
        DELETE FROM `mysql_test`.`test` WHERE `name` = '42';
        DROP TABLE `mysql_test`.`test`;
        DROP DATABASE `mysql_test`;
      EOS
      # mysql throws error if any file exists in the data directory
      system "#{bin}/mysqld", "--log-error-verbosity=3", "--initialize-insecure", "--datadir=#{testpath}/mysql", "--user=#{ENV["USER"]}"
      pid = fork do
        exec "#{opt_bin}/mysqld_safe", "--datadir=#{testpath}/mysql", "--user=#{ENV["USER"]}", "--bind-address=127.0.0.1", "--port=3307", "--socket=#{testpath}/mysql.sock"
      end
      sleep 3
      system "#{bin}/mysql", "--verbose", "--host=127.0.0.1", "--port=3307", "--user=root", "--execute=source #{testpath/"mysql_test.sql"}"
    ensure
      system "#{bin}/mysqladmin", "shutdown", "--user=root", "--host=127.0.0.1", "--port=3307"
      Process.wait pid
    end
  end
end
