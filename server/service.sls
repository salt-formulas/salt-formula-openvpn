{% from "openvpn/map.jinja" import server with context %}
{%- if server.enabled %}

include:
- openvpn.common

/etc/openvpn/server.conf:
  file.managed:
    - source: salt://openvpn/files/server.conf
    - template: jinja
    - require:
      - pkg: openvpn_packages
    - watch_in:
      - service: openvpn_service

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
  - name: openssl dhparam -out dh4096.pem 4096
  - cwd: /etc/openvpn/ssl
  - unless: test -e /etc/openvpn/ssl/dh4096.pem
  - require:
    - file: openvpn_ssl_dir

{%- endif %}