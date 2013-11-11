{%- if pillar.openvpn.enabled %}

include:
- apt

openvpn_packages:
  pkg.installed:
  - names:
    - openvpn

{%- endif %}
