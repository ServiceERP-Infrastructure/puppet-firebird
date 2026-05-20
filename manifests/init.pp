class firebird(
  Boolean $install_dbeaver = false,
  Hash[String, Firebird::FirebirdSource] $version_sources = {},
  Array[Firebird::FirebirdInstance] $instances = [],
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
  }

  $instances.each | Firebird::FirebirdInstance $instance | {
    firebird::instance{ "firebird_instance_${instance['version']}":
      * => $instance,
    }
  }
}
