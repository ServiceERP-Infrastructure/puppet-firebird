define firebird::instance::install_linux (
  Firebird::FirebirdSource $source,
  Stdlib::AbsolutePath $installation_path,
  String[1] $version = $name,
) {
  $packages = [
    'libtommath1',
    'libtommath-dev',
  ]

  package { $packages:
    ensure => installed,
  }
  
  archive { "/tmp/firebird-${version}.tar.gz":
    ensure          => present,
    source          => $source['linux_source'],
    extract         => true,
    extract_path    => $installation_path,
    extract_command => 'tar xfz %s --strip-components=1',
    creates         => "${installation_path}/install.sh",
    cleanup         => true,
  }

  exec { "run_firebird_installer_${version}":
    command     => "${installation_path}/install.sh -silent",
    cwd         => $installation_path,
    path        => ['/usr/bin', '/bin'],
    refreshonly => true,
    subscribe   => [Archive["/tmp/firebird-${version}.tar.gz"]],
  }
}
