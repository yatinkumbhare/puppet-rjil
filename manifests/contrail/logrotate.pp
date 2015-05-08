## Using this instead of
# rjil::jiocloud::logrotate
# as for more number of logs, this is simpler.
class rjil::contrail::logrotate {
  $contrail_logs = [  'contrail-analytic-api',
                      'contrail-collector',
                      'query-engine',
                      'api',
                      'discovery',
                      'schema',
                      'svc-monitor',
                      'contrail-control',
                      'webserver',
                      'jobserver',
  ]

  logrotate::rule{ $contrail_logs:
    path          => "/var/log/contrail/${contrail_logs}.log",
    rotate        => 60,
    rotate_every  => daily,
    compress      => true,
    delaycompress => true,
    ifempty       => false,
    copytruncate  => true,
  }
}