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

  $contrail_logs = ['contrail-api-daily',
                    'contrail-discovery-daily',
                    'contrail-schema-daily',
                    'contrail-svc-monitor-daily',
                    'contrail-ifmap-server'
  ]

  rjil::jiocloud::logrotate { $contrail_logs:
    logdir => '/var/log/contrail'
  }
  
  $contrail_logs_copytruncate = ['contrail-control',
                                'contrail-dns',
  
  ]
  
  rjil::jiocloud::logrotate { $contrail_logs_copytruncate:
    logdir       => '/var/log/contrail',
    copytruncate => true,
  }
  
  include rjil::contrail::logrotate::consolidate

  $contrail_logrotate_delete = ['contrail-config',
                                'contrail-config-openstack',
                                'ifmap-server',
                                ]
  rjil::jiocloud::logrotate { $contrail_logrotate_delete:
    ensure => absent
  }
  
}
