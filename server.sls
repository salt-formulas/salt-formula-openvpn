{%- if pillar.openvpn.server.enabled %}

openvpn_server_packages:
  pkg.installed:
  - names:
    - openvpn

{%- endif %}
