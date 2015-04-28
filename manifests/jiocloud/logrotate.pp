class rjil::jiocloud::logrotate(
  $service,
  $logfile,
  $rotate_every = 'daily',
  $rotate = 60,
  $compress = true,
  $delaycompress = true,
  $ifempty = false,
) {
  include logrotate
  logrotate::rule{$service:
    path => $logfile,
    rotate => $rotate,
    rotate_every => $rotate_every,
    compress => $compress,
    delaycompress => $delaycompress,
    ifempty => $ifempty
    }
  }

