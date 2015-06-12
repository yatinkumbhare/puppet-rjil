#
# Class: rjil::consul_alerts
#  This class to manage consul-alerts
#
#

class rjil::jiocloud::consul::consul_alerts (
  $slack_url              = $::slack_url,
  $check_thresold         = '30',
  $slack_cluster_name     = 'consul-alerts',
  $slack_username         = 'WatchBot',
  $slack_channel          = 'consul-alerts',
  $bin_dir                = '/usr/bin',
) {

  package { 'consul-alerts':
    ensure => present,
  }

  Consul_kv {
    notify => Service['consul-alerts']
  }

  if $slack_url {
    $enabled = 'true'
    consul_kv {
      'consul-alerts/config/notifiers/slack/url':          value => $slack_url;
    }
  } else {
    $enabled = 'false'
  }
  consul_kv {
    'consul-alerts/config/checks/enabled':               value => $enabled;
    'consul-alerts/config/notifiers/slack/enabled':      value => $enabled;
    'consul-alerts/config/checks/check_thresold':        value => $check_thresold;
    'consul-alerts/config/notifiers/slack/cluster_name': value => $slack_cluster_name;
    'consul-alerts/config/notifiers/slack/username':     value => $slack_username;
    'consul-alerts/config/notifiers/slack/channel':      value => $slack_channel;
  }

  file { '/etc/init/consul-alerts.conf':
    owner   => 'root',
    group   => 'root',
    mode    => '0444',
    require => Package['consul-alerts'],
    content => template('rjil/consul-alerts.erb'),
    notify  => Service[consul-alerts]
  }

  service {'consul-alerts':
    ensure  => 'running',
  }

}
