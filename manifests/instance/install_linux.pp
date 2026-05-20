define firebird::instance::install_linux (
  Firebird::FirebirdSource $source,
  Stdlib::AbsolutePath $installation_path,
  String[1] $version = $name,
) {
  archive { "/tmp/firebird-${version}.zip":
    ensure       => present,
    source       => $source['linux_source'],
    extract      => true,
    extract_path => $installation_path,
    creates      => "${installation_path}/firebird",
    cleanup      => true,
  }
}
