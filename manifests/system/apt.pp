## Class rjil::system::apt
## Purpose: configure apt sources
class rjil::system::apt (
  $enable_ubuntu     = true,
  $enable_puppetlabs = true,
  $enable_ceph       = true,
  $enable_rustedhalo = true,
  $proxy             = false,
) {

  ## two settings to be overrided here in hiera
  ## apt::purge_sources_list: true, apt::purge_sources_list_d: true
  include ::apt

  ## All package operations should follow apt::source
  Apt::Source<||> -> Package<||>

  if $enable_puppetlabs {
    include puppet::repo::puppetlabs
  }

  if $enable_ceph {
    include rjil::system::apt::repo::ceph
  }

  if $enable_rustedhalo {
    include rjil::system::apt::repo::rustedhalo
  }

  if $enable_ubuntu {
    include rjil::system::apt::repo::ubuntu
  }

  if ($proxy) {
    file { '/etc/apt/apt.conf.d/90proxy':
      content => "Acquire::Http::Proxy \"${proxy}\";",
      owner => 'root',
      group => 'root',
      mode => '0644'
    }
  } else {
    file { '/etc/apt/apt.conf.d/90proxy':
      ensure => 'absent'
    }
  }
}

