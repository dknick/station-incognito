# ex: syntax=puppet si ts=4 sw=4 et
class incognito {

    package { 'ubuntu-desktop':
        ensure => latest,
        before => [ Service['lightdm'], File['/etc/NetworkManager/NetworkManager.conf'] ],
    }

    file { '/etc/NetworkManager/NetworkManager.conf':
        ensure => present,
        owner  => 'root',
        group  => 'root',
        mode   => '0644',
        source => 'puppet:///modules/incognito/NetworkManager.conf',
        before => Service['lightdm'],
    }

    service { 'lightdm':
        ensure => running,
    }

    class { 'unbound':
        tcp_upstream => true,
    }

    unbound::forward { '.':
        address => [ '8.8.8.8', '8.8.4.4' ],
    }

    class { 'tor':
        socks                      => true,
        relay                      => false,
        sockspolicies              => [{
            policy => 'accept',
            target => '*',
        }],
        usebridges                 => true,
        updatebridgesfromauthority => false,
        bridges                    => [{
            ip          => $::tor_bridge_ip,
            orport      => $::tor_bridge_orport,
            fingerprint => $::tor_bridge_fingerprint,
        }],
    }

    class { 'redsocks':
        bind_address  => '127.0.0.1',
        proxy_address => '127.0.0.1',
        proxy_port    => '9050',
    }

    class { 'shorewall':
        ipv4 => true,
        ipv6 => true,
    }

    shorewall::zone { 'net': }

    shorewall::policy { 'local_local':
        source => '$FW',
        dest   => '$FW',
        action => 'ACCEPT',
    }

    shorewall::policy { 'all_all':
        source   => 'all',
        dest     => 'all',
        action   => 'REJECT',
        priority => '99',
    }

    shorewall::iface { 'eth0':
        zone    => 'net',
        options => [ 'dhcp', 'tcpflags', 'routefilter', 'nosmurfs', 'logmartians' ],
    }

    shorewall::rule { 'tor-bridge':
        action => 'ACCEPT+',
        source => '$FW',
        dest   => "net:${::tor_bridge_ip}",
        proto  => 'tcp',
        port   => $::tor_bridge_orport,
        ipv6   => false,
        order  => '10',
    }

    shorewall::rule { 'tor-tcp':
        action => 'ACCEPT',
        source => '$FW:&eth0',
        dest   => 'all',
        proto  => 'tcp',
        port   => '-',
        ipv6   => false,
    }

    shorewall::rule { 'tor-tcp-redirect':
        action => 'REDIRECT',
        source => '$FW:&eth0',
        dest   => '12345',
        proto  => 'tcp',
        port   => '-',
        sport  => '-',
        ipv6   => false,
    }

    shorewall::rule { 'tor-dns':
        action => 'ACCEPT',
        source => '$FW:&eth0',
        dest   => 'all',
        proto  => 'udp',
        port   => '53',
        ipv6   => false,
    }

    shorewall::rule { 'tor-dns-redirect':
        action => 'REDIRECT',
        source => '$FW:&eth0',
        dest   => '5300',
        proto  => 'udp',
        port   => '53',
        sport  => '-',
        ipv6   => false,
    }

    shorewall::port { 'ssh':
        application => 'SSH',
        source      => 'all',
        action      => 'ACCEPT',
    }

    Package {
        before => Service['shorewall'],
    }

    Service['unbound'] -> Service['tor'] -> Service['shorewall'] -> Service['redsocks']
}
