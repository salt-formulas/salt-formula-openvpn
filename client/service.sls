{% from "openvpn/map.jinja" import client with context %}
{%- if client.enabled %}

include:
- openvpn.common

{%- for tunnel_name, tunnel in client.tunnel.iteritems() %}

/etc/openvpn/{{ tunnel_name }}.conf:
  file.managed:
    - source: salt://openvpn/files/client.conf
    - template: jinja
    - default:
      tunnel_name: '{{ tunnel_name }}'
    - require:
      - pkg: openvpn_packages
    - watch_in:
      - service: openvpn_service

{%- endfor %}

{%- endif %}