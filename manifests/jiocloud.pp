class rjil::jiocloud {
  file { '/usr/local/bin/jiocloud-update.sh':
    source => 'puppet:///modules/rjil/update.sh',
    mode => '0755',
    owner => 'root',
    group => 'root'
  }

  file { '/usr/local/bin/poll-upgrade.sh':
    source => 'puppet:///modules/rjil/poll-upgrade.sh',
    mode => '0755',
    owner => 'root',
    group => 'root'
  } ->
  file { '/etc/init/poll-upgrade.conf':
    source => 'puppet:///modules/rjil/poll-upgrade.upstart',
    mode => '0644',
    owner => 'root',
    group => 'root'
  } -> 
  service { 'poll-upgrade':
    ensure   => 'running',
    enable   => true,
    provider => 'upstart',
  }
}
