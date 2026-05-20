define firebird::instance::install_windows(
  Firebird::FirebirdSource $source,
  Stdlib::AbsolutePath $installation_path,
  String[1] $version = $name,
) {
  file { $installation_path:
    ensure => directory,
  }

  archive { "C:\\Windows\\Temp\\${version}.zip":
    ensure       => present,
    source       => $source['windows_source'],
    extract      => true,
    extract_path => $installation_path,
    creates      => "${installation_path}\\firebird.exe",
    cleanup      => true,
  }
}
