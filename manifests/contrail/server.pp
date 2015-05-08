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

  class { 'rjil::contrail::logrotate': }

}
