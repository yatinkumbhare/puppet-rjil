class rjil::jiocloud::aptmirror {
  class { 'apt_mirror':
    enabled => false
  }

  apt_mirror::mirror { 'ubuntu':
    mirror     => 'archive.ubuntu.com',
    os         => 'ubuntu',
    release    => ['trusty', 'trustry-updates', 'trusty-security'],
    components => ['main', 'universe', 'restricted', 'multiverse'],
    source     => true,
  }

  apt_mirror::mirror { 'rustedhalo':
    mirror     => 'jiocloud.rustedhalo.com',
    os         => 'ubuntu',
    release    => ['trusty'],
    components => ['main'],
    source     => true,
  }
}
