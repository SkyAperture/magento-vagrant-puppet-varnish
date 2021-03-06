/**
 * Set defaults
 */
# set default path for execution
Exec { path => '/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin' }

/**
 * Run "apt-get update" before installing packages
 */
exec { 'apt-update':
    command => '/usr/bin/apt-get update'
}
Exec['apt-update'] -> Package <| |>


package { 'curl':
    ensure => 'present',
}

group { 'puppet':
    ensure => 'present',
}

class { 'apache2':
    document_root => '/vagrant/www',
}

/**
 * MySQL config
 */
class { 'mysql':
    root_pass => 'r00t',
}

/**
 * Magento config
 */
class { 'magento':
    /* install magento [true|false] */
    install =>  false,

    /* magento version */
    version     => '1.8.1.0',
    #version    => '1.7.0.2',
    #version    => '1.7.0.1',
    #version    => '1.7.0.0',
    #version    => '1.6.2.0',
    #version    => '1.6.1.0',
    #version    => '1.6.0.0',
    #version    => '1.5.1.0',
    #version    => '1.5.0.1',

    /* magento database settings */
    db_user     => 'magento',
    db_pass     => 'magento',

    /* magento admin user */
    admin_user  => 'admin',
    admin_pass  => '123123abc',

    /* use rewrites [yes|no] */
    use_rewrites => 'no',

    /* magento host and port */
    host => 'magento.localhost',
    port => 8080 /* should be identical to forwarded port in Vagrantfile */
}

class { 'varnish':
    /* install varnish [true|false] */
    install => false,

    /* varnish version */
    version   => '4.0',
    #version   => '3.0',
    #version   => '2.1',
}

/**
 * Import modules
 */
include apt
include mysql
include apache2
include php5
include composer
include magento
include varnish
