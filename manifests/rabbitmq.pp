#
# Class: rjil::rabbitmq
#  This class to manage contrail rabbitmq dependency
#
# == Hiera elements required
#
# rabbitmq::manage_repo: no
#   This parameter to disable apt repo management in rabbitmq module
#
# rabbitmq::admin::enable: no
#   To disable rabbitmqadmin
#   Note: In original contrail installation it is disabled, so starting with
#   disabling it.
#


class rjil::rabbitmq {

  rjil::test { 'check_rabbitmq.sh': }

  include ::rabbitmq

}
