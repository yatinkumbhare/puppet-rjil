define rjil::jiocloud::jenkins::cloudenv(
  $vars = {}
) {
  file { "/var/lib/jenkins/cloud.${name}.env":
    content => template("rjil/cloudenv.erb"),
    owner => jenkins,
    group => jenkins,
    mode => '0600'
  }
}
