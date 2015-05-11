define rjil::jiocloud::logrotate(
  $logdir        = "/var/log",
  $service       = $name,
  $rotate_every  = 'daily',
  $rotate        = 60,
  $compress      = true,
  $delaycompress = true,
  $ifempty       = false,
) {
  if ($logdir =~ /\/$/) {
    $logfile = "${logdir}${name}.log" 
  } else {
    $logfile = "${logdir}/${name}.log" 
  }
  logrotate::rule{ $service:
    path          => $logfile,
    rotate        => $rotate,
    rotate_every  => $rotate_every,
    compress      => $compress,
    delaycompress => $delaycompress,
    ifempty       => $ifempty
  }
}
