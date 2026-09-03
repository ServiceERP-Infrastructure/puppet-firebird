define firebird::instance::init (
  Stdlib::AbsolutePath $installation_path,
  String[1] $initial_password,
) {
  $sql_file_path = "${installation_path}/init_user.sql"

  file { $sql_file_path:
    ensure  => file,
    content => epp("${module_name}/init_user.sql.epp", {
      initial_password => $initial_password,
    }),
    notify  => [Exec['execute init sql']],
  }

  exec { 'execute init sql':
    command     => ['isql', '-user', 'sysdba', '-input', $sql_file_path, 'employee'],
    path        => ['/usr/bin', '/bin', "${installation_path}/bin"],
    refreshonly => true,
  }
}
