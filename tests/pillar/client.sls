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
          engine: none
