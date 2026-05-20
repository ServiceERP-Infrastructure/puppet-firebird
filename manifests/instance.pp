define firebird::instance(
  String[1] $version,
  Integer $port,
  String[1] $initial_password = 'masterkey',
  Boolean $manage_firewall = true,
  Boolean $manage_package = true,
  Boolean $manage_service = true,
  Hash $config = {},
) {
  $version_source = $firebird::version_sources[$version]
  $service_name = $version_source['service_name']

  if ($version_source == undef) {
    fail("no version sources found for ${version}")
  }

  $version_name = "Firebird_${version}"

  case $facts['os']['family'] {
    'windows':  {
      $base_path = "C:\\Program Files (x86)\\Firebird\\"
      $installation_path = "${base_path}\\${version}"
      $full_service_name = "FirebirdServer${service_name}"
      
      file { $base_path:
        ensure => directory,
      }
      
      if ($manage_package) {
        firebird::instance::install_windows { $version_name :
          installation_path => $installation_path,
          source            => $version_source,
        }
      }
      
      firebird::instance::config { "firebird_windows_config_${version}":
        installation_path => $installation_path,
        port              => $port,
        config            => $config,
        service_name      => $full_service_name,
        manage_service    => $manage_service,
      }

      if ($manage_service) {
        exec { 'install windows firebird service':
          command => ['install_service.bat', $service_name],
          cwd     => $installation_path,
          path    => [$installation_path, 'C:\\Windows\\System32\\'],
          unless  => "sc.exe query ${full_service_name}"
        }

        service { $full_service_name:
          ensure  => running,
          enable  => true,
          require => [Exec['install windows firebird service']],
        }
      }
      if ($manage_firewall) {
        windows_firewall::exception { "Firebird ${version}":
          ensure       => 'present',
          direction    => 'in',
          action       => 'allow',
          enabled      => true,
          protocol     => 'TCP',
          local_port   => $port,
          display_name => "Firebird ${version}",
          description  => "Firebird ${version} - Managed by Puppet",
        }
      }
    }
    'Debian': {
      $base_path = '/opt/firebird_installer'
      $installation_path = "${base_path}/${version}"
      $full_service_name = "FirebirdServer${service_name}"

      file { $installation_path:
        ensure => directory,
        owner  => 'firebird',
        group  => 'firebird',
      }

      if ($manage_package) {
        firebird::instance::install_linux { $version_name :
          installation_path => $installation_path,
          source            => $version_source,
        }
      }

      if ($manage_firewall) {
        $rules_version_name = regsubst($version, '.', '_', 'G')

        nftables::simplerule{"wireguard_firebird_${rules_version_name}":
          action  => 'accept',
          comment => "allow Firebird (${version_name}) traffic to port ${port}",
          proto   => 'tcp',
          dport   => $port,
        }
      }
    }
    default:  {
      fail("not supported os ${facts['os']['name']}")
    }
  }

  firebird::instance::init { 'firebird_init':
    installation_path => $installation_path,
    initial_password  => $initial_password,
  }
}
