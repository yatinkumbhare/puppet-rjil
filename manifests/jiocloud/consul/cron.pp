class rjil::jiocloud::consul::cron {

  file { "/usr/local/bin/publish-consul-servers.py":
    source => 'puppet:///modules/rjil/publish-consul-servers.py',
    mode => "0755"
  }

  cron { "publish-consul-servers":
    command => "python /usr/local/bin/publish-consul-servers.py ${::consul_discovery_token}"
  }
}
