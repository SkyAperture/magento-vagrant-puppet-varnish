class varnish($install, $version) {

    if $install {

        # Installs the GPG key
        exec { 'import-key':
          path    => '/bin:/usr/bin',
          command => 'curl http://repo.varnish-cache.org/debian/GPG-key.txt | apt-key add -',
          unless  => 'apt-key list | grep servergrove-ubuntu-precise',
          require => Package['curl'],
        }

        # Creates the source file for the ServerGrove repository
        file { 'varnish.repo':
          path    => '/etc/apt/sources.list.d/varnish.list',
          ensure  => present,
          content => "deb http://repo.varnish-cache.org/ubuntu/ precise varnish-${version}",
          require => Exec['import-key'],
        }

        # Refreshes the list of packages
        exec { 'apt-get-update':
          command => 'apt-get update',
          path    => ['/bin', '/usr/bin'],
          require => File['varnish.repo'],
        }

        package { 'varnish':
          ensure => installed,
          require => Exec['apt-get-update']
        }

        service { "varnish":
          ensure  => "running",
          require => Package['varnish']
        }
    }
}
