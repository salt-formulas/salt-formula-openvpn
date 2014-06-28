{% from "openvpn/map.jinja" import server with context %}
{%- if server.enabled %}

/etc/openvpn/server.conf:
  file.managed:
    - source: salt://openvpn/files/server.conf
    - template: jinja
    - require:
      - pkg: openvpn_packages
    - watch_in:
      - service: openvpn_service

{%- endif %}