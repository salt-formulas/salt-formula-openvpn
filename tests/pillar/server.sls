logrotate:
  server:
    enabled: true
    bind:
      protocol: tcp
    routes:
      - network: 192.168.1.0
        netmask: 255.255.255.0
    interface:
      network: 10.0.101.0
      netmask: 255.255.255.0
    auth:
      type: pam
