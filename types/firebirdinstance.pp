type Firebird::FirebirdInstance = Struct[
  {
    ensure           => Optional[Enum['present']],
    version          => String[1],
    port             => Stdlib::Port,
    initial_password => String[1],
    manage_firewall  => Optional[Boolean],
    manage_package   => Optional[Boolean],
    manage_service   => Optional[Boolean],
    config           => Optional[Hash],
  }
]
