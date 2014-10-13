## Class: rjil::system
## Purpose: to group all system level configuration together.

class rjil::system {

  ##
  ## It is decided to keep all devices in UTC timezone
  ## This will keep all our systems in single timezone even if we have servers
  ## outside
  ##    and in case we might have to get any external providers' services
  ##

  include ::timezone

  include rjil::system::apt
  include rjil::system::accounts

  ## Setup tests
  rjil::test {'check_timezone.sh':}

  Anchor['rjil::system::start'] -> Class['::timezone'] -> Anchor['rjil::system::end']
  contain rjil::system::ntp

  ## apt and accounts have circular dependancy, so making both of them dependant to anchors
  anchor { 'rjil::system::start':
    before => [Class['rjil::system::apt'],Class['rjil::system::accounts']],
  }
  anchor { 'rjil::system::end':
    require => [Class['rjil::system::apt'],Class['rjil::system::accounts']],
  }

  ##
  ## Added security banner messages
  ##

  $issue = [ '/etc/issue.net','/etc/issue' ]

  file { $issue:
    ensure        => file,
    owner         => root,
    group         => root,
    mode          => 644,
    source        => "puppet:///modules/${module_name}/_etc_issue",
  }
}
