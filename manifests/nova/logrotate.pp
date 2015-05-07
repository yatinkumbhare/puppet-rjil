class rjil::nova::logrotate {
  $nova_logs = ['nova-api',
                'nova-cert',
                'nova-conductor',
                'nova-consoleauth',
                'nova-novncproxy',
                'nova-scheduler',
                'nova-manage',
  ]

  logrotate::rule{ $nova_logs:
    path          => "/var/log/nova/${nova_logs}.log",
    rotate        => 60,
    rotate_every  => daily,
    compress      => true,
    delaycompress => true,
    ifempty       => false,
    copytruncate  => true,
  }
}