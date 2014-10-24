class rjil::jiocloud::aptrepo(
  $basedir = '/var/lib/reprepro',
  $repositories = {},
  $distributions = {}
) {
  include ::reprepro

  create_resources(::reprepro::repository, $repositories, { basedir => $basedir })
  create_resources(::reprepro::distribution, $distributions, { basedir       => $basedir,
                                                               architectures => 'amd64 i386',
                                                               components    => 'main',
                                                               not_automatic => 'No' })

}
