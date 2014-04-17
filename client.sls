{%- if pillar.openvpn.client.enabled %}

openvpn_client_packages:
  pkg.installed:
  - names:
    - openvpn

{%- endif %}
