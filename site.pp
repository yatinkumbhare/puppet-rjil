class { 'rjil': }
class { 'rjil::server': }
class { 'rjil::jiocloud': }
class { 'rjil::jiocloud::sources': }
class { 'rjil::jiocloud::etcd':
  discovery => true,
  discovery_token => $::etcd_discovery_token
}
class { 'apache': }
