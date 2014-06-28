
# OpenVPN

OpenVPN can tunnel any IP subnetwork or virtual ethernet adapter over a single UDP or TCP port, configure a scalable, load-balanced VPN server farm using one or more machines which can handle thousands of dynamic connections from incoming VPN clients.

## Sample pillars

Simple OpenVPN server

    openvpn:
      server:
        enabled: true
        device: tup
        ssl:
          authority: Domain_Service_CA
          certificate: server.domain.com
        bind:
          address: 0.0.0.0
          port: 1194
          protocol: tcp

OpenVPN server with private subnet with DHCP and predefined clients

    openvpn:
      server:
        ...
        interface:
          type: subnet
          network: 10.0.8.0
          netmask: 255.255.255.0
          dhcp_pool:
            start: 10.0.8.100
            end: 10.0.8.199
          clients:
          - host: client1.domain.com
            address: 10.0.8.12
          - host: client2.domain.com
            address: 10.0.8.13


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
            ssl:
              authority: Domain_Service_CA
              certificate: client.domain.com

## Read more

* https://github.com/luxflux/puppet-openvpn
* https://github.com/ConsumerAffairs/salt-states/blob/master/openvpn.sls
