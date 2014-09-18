###
## Class: rjil::contrail
###
class rjil::contrail::server () {

  ##
  ## Add test scripts
  ##
  ## rabbitmq

  rjil::test { 'check_rabbitmq.sh': }

  include ::contrail
}
