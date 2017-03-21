openvpn:
  client:
    enabled: true
    tunnel:
      tunnel01:
        autostart: true
        servers:
        - host: 10.0.0.1
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
        servers:
        - host: 10.0.0.1
          port: 1194
        protocol: tcp
        device: tup
        compression: true
        ssl:
          engine: salt
          authority: Domain_Service_CA
          certificate: client.domain.com
