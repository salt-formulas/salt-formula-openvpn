openvpn:
  server:
    enabled: true
    bind:
      protocol: tcp
    ssl:
      ca_file: /etc/openvpn/ssl/ca.crt
      key_file: /etc/openvpn/ssl/server.key
      cert_file: /etc/openvpn/ssl/server.crt
    routes:
      - network: 192.168.1.0
        netmask: 255.255.255.0
    interface:
      network: 10.0.101.0
      netmask: 255.255.255.0
    auth:
      type: pam
