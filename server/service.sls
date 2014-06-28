{% from "openvpn/map.jinja" import server with context %}
{%- if server.enabled %}

include:
- openvpn.common

net.ipv4.ip_forward:
  sysctl.present:
    - value: 1

/etc/openvpn/server.conf:
  file.managed:
    - source: salt://openvpn/files/server.conf
    - template: jinja
    - mode: 600
    - require:
      - pkg: openvpn_packages
    - watch_in:
      - service: openvpn_service

/etc/openvpn/ipp.txt:
  file.managed:
    - source: salt://openvpn/files/ipp.txt
    - template: jinja
    - mode: 600
    - require:
      - pkg: openvpn_packages

/etc/openvpn/ssl/server.crt:
  file.managed:
  - source: salt://pki/{{ server.ssl.authority }}/certs/{{ server.ssl.certificate }}.cert.pem
  - require:
    - file: openvpn_ssl_dir

/etc/openvpn/ssl/server.key:
  file.managed:
  - source: salt://pki/{{ server.ssl.authority }}/certs/{{ server.ssl.certificate }}.key.pem
  - require:
    - file: openvpn_ssl_dir

/etc/openvpn/ssl/ca.crt:
  file.managed:
  - source: salt://pki/{{ server.ssl.authority }}/{{ server.ssl.authority }}-chain.cert.pem
  - require:
    - file: openvpn_ssl_dir

dh_key_install:
  cmd.run:
  - name: openssl dhparam -out dh2048.pem 2048
  - cwd: /etc/openvpn/ssl
  - unless: test -e /etc/openvpn/ssl/dh2048.pem
  - require:
    - file: openvpn_ssl_dir

{%- endif %}