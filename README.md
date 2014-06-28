
# OpenVPN

OpenVPN can tunnel any IP subnetwork or virtual ethernet adapter over a single UDP or TCP port, configure a scalable, load-balanced VPN server farm using one or more machines which can handle thousands of dynamic connections from incoming VPN clients.

## Sample pillars

Simple OpenVPN server

    openvpn:
      server:
        enabled: true
        bind:
          address: 0.0.0.0
          port: 1194
          protocol: tcp
        device: tup

Simple OpenVPN client with multiple servers

    openvpn:
      client:
        enabled: true
        tunnel:
          tunnel_name:
            autostart: true
            servers:
            - host: 10.0.0.1
              port: 1194
            - host: 10.0.0.2
              port: 1194
            protocol: tcp
            device: tup

## Read more

* https://github.com/luxflux/puppet-openvpn
* https://github.com/ConsumerAffairs/salt-states/blob/master/openvpn.sls
