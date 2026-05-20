define firebird::instance::config (
  Stdlib::AbsolutePath $installation_path,
  Integer $port,
  String[1] $service_name,
  Boolean $manage_service = true,
  Hash $config = {},
) {
  $content = epp('firebird/firebird.conf.epp', {
    default_db_cache_pages      => case $config['default_db_cache_pages'] {
      undef: { '30K' }
      default: { $config['default_db_cache_pages'] }
    },
    temp_cache_limit            => case $config['temp_cache_limit'] {
      undef: { '1G' }
      default: { $config['temp_cache_limit'] }
    },
    lock_mem_size               => case $config['lock_mem_size'] {
      undef: { '30M' }
      default: { $config['lock_mem_size'] }
    },
    file_system_cache_threshold => case  $config['file_system_cache_threshold'] {
      undef: { '2M' }
      default: { $config['file_system_cache_threshold'] }
    },
    port                        => $port,
  })

  if ($manage_service) {
    $notifies = [Service[$service_name]]
  } else {
    $notifies = []
  }

  file { "${installation_path}/firebird.conf":
    ensure  => file,
    notify  => $notifies,
    content => $content,
  }
}
