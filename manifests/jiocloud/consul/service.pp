define rjil::jiocloud::consul::service(
  $port,
  $check_command = "true",
  $interval      = '10s'
) {
  $service_hash = {
    service => {
      name  => $name,
      port  => $port + 0,
      check => {
        script => $check_command,
        interval => $interval
      }
    }
  }

  file { "/etc/consul/$name.json":
    ensure => "present",
    content => template('rjil/consul.service.erb'),
  } ~> Exec['reload-consul']
}
