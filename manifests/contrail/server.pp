###
## Class: rjil::contrail
###
class rjil::contrail::server (
  $enable_analytics = true,
) {

  ##
  # Added tests
  ##
  $contrail_tests = ['ifmap.sh','contrail-api.sh',
                      'contrail-control.sh','contrail-discovery.sh',
                      'contrail-dns.sh','contrail-schema.sh',
                      'contrail-webui-webserver.sh','contrail-webui-jobserver.sh']
  rjil::test {$contrail_tests:}

  if $enable_analytics {
    rjil::test {'contrail-analytics.sh':}
  }

  include ::contrail
}
## Using this instead of rjil::jiocloud::logrotate as for more number of logs, this is simpler.
class contrail_logs {
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
    path          => "/var/log/contrail/${ccontrail_logs}.log",
    rotate        => 60,
    rotate_every  => daily,
    compress      => true,
    delaycompress => true,
    ifempty       => false,
    copytruncate  => true,
  } 
}
class { 'contrail_logs': }
