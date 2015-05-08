class rjil::nova::logrotate::manage {
    rjil::jiocloud::logrotate {'nova-manage':
        service => 'nova-manage',
        logfile => '/var/log/nova/nova-manage.log'
    }
}