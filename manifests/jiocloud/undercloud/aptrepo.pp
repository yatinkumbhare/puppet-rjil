class rjil::jiocloud::undercloud::aptrepo(
  $basepath = '/var/lib/reprepro'
) {
  class { '::reprepro':
    basepath => $basepath
  }

  reprepro::repository { 'internal':
    basepath => $basepath
  }

  reprepro::distribution { 'precise':
    basedir       => $basedir,
    repository    => 'internal',
    origin        => 'JioCloud',
    label         => 'JioCloud',
    suite         => 'trusty',
    architectures => 'amd64 i386',
    components    => 'main',
    description   => 'Package repository for local customisations',
    sign_with     => 'F4D5DAA8',
    not_automatic => 'No',
  }
}
