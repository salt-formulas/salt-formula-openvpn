{%- if pillar.openvpn.server.enabled %}

openvpn_packages:
  pkg.installed:
  - names:
    - openvpn

{%- endif %}
