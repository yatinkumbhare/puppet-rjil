class rjil::base {
  # install users
  include rjil
  include rjil::jiocloud
  include rjil::system
  realize (
    Rjil::Localuser['jenkins'],
    Rjil::Localuser['soren'],
    Rjil::Localuser['bodepd'],
  )
}

