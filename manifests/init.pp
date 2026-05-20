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
  }

  $instances.each | String $instance_name, Firebird::FirebirdInstance $instance | {
    firebird::instance{ "firebird_instance_${instance_name}":
      * => $instance,
    }
  }
}
