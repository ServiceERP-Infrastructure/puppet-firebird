define firebird::instance::install_linux (
  Firebird::FirebirdSource $source,
  Stdlib::AbsolutePath $installer_path,
  Stdlib::AbsolutePath $installation_path,
  String[1] $version = $name,
) {
  archive { "${installer_path}/firebird-${version}.tar.gz":
    ensure          => present,
    source          => $source['linux_source'],
    extract         => true,
    extract_path    => $installer_path,
    extract_command => 'tar xfz %s --strip-components=1',
    creates         => "${installer_path}/install.sh",
    cleanup         => true,
  }

  exec { "run_firebird_installer_${version}":
    command     => "${$installer_path}/install.sh -silent -path ${installation_path}",
    cwd         => $installer_path,
    path        => ['/usr/bin', '/bin'],
    refreshonly => true,
    subscribe   => [Archive["${installer_path}/firebird-${version}.tar.gz"]],
    user        => 'firebird',
  }
}
