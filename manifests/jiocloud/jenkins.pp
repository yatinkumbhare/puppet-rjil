class rjil::jiocloud::jenkins {
  $packages = ['openjdk-7-jre-headless',
               'sbuild',
               'ubuntu-dev-tools',
               'python-pip',
               'npm',
               'git',
               'python-lxml',
               'python-dev',
               'autoconf',
               'libtool',
               'haveged',
               'apt-cacher-ng',
               'debhelper',
               'pkg-config',
               'bundler',
               'libxml2-utils',
               'build-essential',
               'libffi-dev',
               'python-virtualenv']

  package { $packages:
    ensure => 'installed'
  }
}
