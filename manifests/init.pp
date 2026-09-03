class firebird(
  Boolean $install_dbeaver = false,
  Hash[String, Firebird::FirebirdSource] $version_sources = {},
  Hash[String, Firebird::FirebirdInstance] $instances = [],
) {
  if ($install_dbeaver) {
    if $facts['os']['name'] == 'windows' {
      package { 'dbeaver':
        ensure   => installed,
        provider => 'chocolatey',
      }
    }
  }

  if ($facts['os']['family'] == 'Debian') {
    group {'firebird':
      ensure => present,
    }
    user {'firebird':
      ensure => present,
      gid    => 'firebird',
    }
    file { '/opt/firebird_installer':
      ensure => directory,
      owner  => 'firebird',
      group  => 'firebird',
    }

    $packages = [
      'libtommath1',
      'libtommath-dev',
      'libncurses-dev',
      'libicu-dev',
    ]

    package { $packages:
      ensure => installed,
    }

    file { '/usr/lib/x86_64-linux-gnu/libtommath.so.0':
      ensure => link,
      target => '/usr/lib/x86_64-linux-gnu/libtommath.so.1',
    }
  }

  $instances.each | String $instance_name, Firebird::FirebirdInstance $instance | {
    firebird::instance{ "firebird_instance_${instance_name}":
      * => $instance,
    }
  }
}
