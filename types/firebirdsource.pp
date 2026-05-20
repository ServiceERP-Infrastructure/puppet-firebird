type Firebird::FirebirdSource = Struct[
  {
    service_name   => String[1],
    windows_source => Optional[Stdlib::HTTPUrl],
    linux_source   => Optional[Stdlib::HTTPUrl]
  }
]
