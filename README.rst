
=======
OpenVPN
=======

OpenVPN can tunnel any IP subnetwork or virtual ethernet adapter over a single UDP or TCP port, configure a scalable, load-balanced VPN server farm using one or more machines which can handle thousands of dynamic connections from incoming VPN clients.

Sample pillars
==============

Simple OpenVPN server

.. code-block:: yaml

    openvpn:
      server:
        enabled: true
        device: tun
        ssl:
          authority: Domain_Service_CA
          certificate: server.domain.com
        bind:
          address: 0.0.0.0
          port: 1194
          protocol: tcp

OpenVPN server with private subnet with DHCP and predefined clients

.. code-block:: yaml

    openvpn:
      server:
        ...
        interface:
          topology: subnet
          network: 10.0.8.0
          netmask: 255.255.255.0
          dhcp_pool:
            start: 10.0.8.100
            end: 10.0.8.199
          clients:
          - name: client1.domain.com
            address: 10.0.8.12
          - name: client2.domain.com
            address: 10.0.8.13

.. code-block:: yaml

    openvpn:
      server:
        ...
        topology: subnet
        interface:
          network: 10.0.8.0
          netmask: 255.255.255.0
        dhcp_pool:
          start: 10.0.8.100
          end: 10.0.8.199
        topology: gateway
        device: tun
        mode: p2p
        interface:
          network: 10.0.8.0
          netmask: 255.255.255.0
        endpoint:
          local: 10.8.0.1
          remote: 10.8.0.2
        dhcp_pool:
          start: 10.8.0.4
          end: 10.8.0.255
        routes:
        - network: 10.8.0.1
          netmask: 255.255.255.255
        - network: 10.0.110.0
          netmask: 255.255.255.0
        - network: 10.0.101.0
          netmask: 255.255.255.0

Single OpenVPN client with multiple servers

.. code-block:: yaml

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
            compression: true
            ssl:
              authority: Domain_Service_CA
              certificate: client.domain.com

Multiple OpenVPN clients

.. code-block:: yaml

    openvpn:
      client:
        enabled: true
        tunnel:
          tunnel01:
            autostart: true
            server:
              host: 10.0.0.1
              port: 1194
            protocol: tcp
            device: tup
            compression: true
            ssl:
              engine: salt
              authority: Domain_Service_CA
              certificate: client.domain.com
          tunnel02:
            autostart: true
            server:
              host: 10.0.0.1
              port: 1194
            protocol: tcp
            device: tup
            compression: true
            ssl:
              engine: salt
              authority: Domain_Service_CA
              certificate: client.domain.com


Read more
=========

* https://github.com/luxflux/puppet-openvpn
* https://github.com/ConsumerAffairs/salt-states/blob/master/openvpn.sls
* https://help.ubuntu.com/13.10/serverguide/openvpn.html
