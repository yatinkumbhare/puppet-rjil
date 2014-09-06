class rjil::system::apt::repo::ubuntu(
  $location    = 'http://in.archive.ubuntu.com/ubuntu',
  $release     = 'trusty',
  $repos       = 'main restricted universe multiverse',
  $include_src = false,
) {

  ::apt::source { "${release}-updates":
    location    => $location,
    release     => "${release}-updates",
    repos       => $repos,
    include_src => $include_src,
  }

  ::apt::source { $release:
    location => $location,
    release  => $release,
    repos    => $repos,
    include_src => $include_src,
  }

}
