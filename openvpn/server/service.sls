{% from "openvpn/map.jinja" import server with context %}
{%- if server.enabled %}

include:
- openvpn.common

{%- if grains.get('virtual_subtype', None) not in ['Docker', 'LXC'] %}

net.ipv4.ip_forward:
  sysctl.present:
  - value: 1

{%- endif %}

/etc/openvpn/server.conf:
  file.managed:
  - source: salt://openvpn/files/server.conf
  - template: jinja
  - mode: 600
  - require:
    - pkg: openvpn_packages
  {%- if not grains.get('noservices', False) %}
  - watch_in:
    - service: openvpn_service
  {%- endif %}

/etc/openvpn/ipp.txt:
  file.managed:
  - source: salt://openvpn/files/ipp.txt
  - template: jinja
  - mode: 600
  - require:
    - pkg: openvpn_packages
  {%- if not grains.get('noservices', False) %}
  - watch_in:
    - service: openvpn_service
  {%- endif %}

{%- if server.ssl.get('key') %}
/etc/openvpn/ssl/server.key:
  file.managed:
    - contents_pillar: openvpn:server:ssl:key
    - mode: 600
    {%- if not grains.get('noservices', False) %}
    - watch_in:
      - service: openvpn_service
    {%- endif %}
{%- endif %}

{%- if server.ssl.get('cert') %}
/etc/openvpn/ssl/server.crt:
  file.managed:
    - contents_pillar: openvpn:server:ssl:cert
    {%- if not grains.get('noservices', False) %}
    - watch_in:
      - service: openvpn_service
    {%- endif %}
{%- endif %}

{%- if server.ssl.get('ca') %}
/etc/openvpn/ssl/ca.crt:
  file.managed:
    - contents_pillar: openvpn:server:ssl:ca
    {%- if not grains.get('noservices', False) %}
    - watch_in:
      - service: openvpn_service
    {%- endif %}
{%- endif %}

openvpn_generate_dhparams:
  cmd.run:
  - name: openssl dhparam -out /etc/openvpn/ssl/dh2048.pem 2048
  - creates: /etc/openvpn/ssl/dh2048.pem
  {%- if not grains.get('noservices', False) %}
  - watch_in:
    - service: openvpn_service
  {%- endif %}

{%- if server.auth is defined %}
{%- if server.auth.type == 'pam' %}
openvpn_auth_pam:
  file.symlink:
    - name: /etc/pam.d/openvpn
    - target: /etc/pam.d/common-auth
    {%- if not grains.get('noservices', False) %}
    - watch_in:
      - service: openvpn_service
    {%- endif %}
{%- endif %}
{%- endif %}

{%- endif %}
