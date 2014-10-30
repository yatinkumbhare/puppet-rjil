#
# sets up rustedhalo apt mirror
#
class rjil::jiocloud::aptmirror {

  class { 'apt_mirror':
    enabled => false
  }

  apt_mirror::mirror { 'ubuntu':
    mirror     => 'archive.ubuntu.com',
    os         => 'ubuntu',
    release    => ['trusty', 'trusty-updates', 'trusty-security'],
    components => ['main', 'universe', 'restricted', 'multiverse'],
    source     => true,
  }

  apt_mirror::mirror { 'internal':
    mirror     => 'apt.internal.jiocloud.com',
    os         => 'internal',
    release    => ['trusty'],
    components => ['main'],
    source     => false,
  }

  apt_mirror::mirror { 'datastax':
    mirror     => 'debian.datastax.com',
    os         => 'community',
    release    => ['stable'],
    components => ['main'],
    source     => false,
  }

  apt_mirror::mirror { 'rustedhalo':
    mirror     => 'jiocloud.rustedhalo.com',
    os         => 'ubuntu',
    release    => ['trusty'],
    components => ['main'],
    source     => true,
  }

  apt_mirror::mirror { 'jenkins':
    mirror     => 'pkg.jenkins-ci.org',
    os         => 'debian',
    release    => ['binary/'],
    components => [],
  }

  file { '/var/spool/apt-mirror/snapshots':
    ensure => 'directory',
    owner  => 'jenkins',
  } ->
  file { '/var/spool/apt-mirror/snapshots/snapshot.sh':
    owner  => 'jenkins',
    mode   => '0755',
    source => 'puppet:///modules/rjil/snapshot.sh'
  }

  include ::apache

  apache::vhost { 'snapshots.internal.jiocloud.com':
    port    => '80',
    docroot => '/var/spool/apt-mirror/snapshots'
  }

  ::sudo::conf { 'jenkins-mirror':
    content  => "#Managed By Puppet\njenkins ALL=(ALL) NOPASSWD: /usr/bin/apt-mirror /etc/apt/mirror.list",
  }
}
