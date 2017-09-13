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
  - watch_in:
    - service: openvpn_service

/etc/openvpn/ipp.txt:
  file.managed:
  - source: salt://openvpn/files/ipp.txt
  - template: jinja
  - mode: 600
  - require:
    - pkg: openvpn_packages
  - watch_in:
    - service: openvpn_service

{%- if server.ssl.get('key') %}
/etc/openvpn/ssl/server.key:
  file.managed:
    - contents_pillar: openvpn:server:ssl:key
    - mode: 600
    - watch_in:
      - service: openvpn_service
{%- endif %}

{%- if server.ssl.get('cert') %}
/etc/openvpn/ssl/server.crt:
  file.managed:
    - contents_pillar: openvpn:server:ssl:cert
    - watch_in:
      - service: openvpn_service
{%- endif %}

{%- if server.ssl.get('ca') %}
/etc/openvpn/ssl/ca.crt:
  file.managed:
    - contents_pillar: openvpn:server:ssl:ca
    - watch_in:
      - service: openvpn_service
{%- endif %}

openvpn_generate_dhparams:
  cmd.run:
  - name: openssl dhparam -out /etc/openvpn/ssl/dh2048.pem 2048
  - creates: /etc/openvpn/ssl/dh2048.pem
  - watch_in:
    - service: openvpn_service

{%- if server.auth is defined %}
{%- if server.auth.engine == 'pam' %}
openvpn_auth_pam:
  file.symlink:
    - name: /etc/pam.d/openvpn
    - target: /etc/pam.d/common-auth
    - watch_in:
      - service: openvpn_service
{%- endif %}
{%- if server.auth.engine == 'google-authenticator' %}
openvpn_auth_packages:
  pkg.installed:
  - name: libpam-google-authenticator

openvpn_auth_pam:
  file.copy:
    - name: /etc/pam.d/openvpn
    - source: /etc/pam.d/common-auth
    - watch_in:
      - service: openvpn_service
    - require:
      - pkg: openvpn_auth_packages

openvpn_auth_google_pam:
  file.append:
    - name: /etc/pam.d/openvpn
    - text: auth    required                        pam_google_authenticator.so
    - ignore_whitespace: False
    - watch_in:
      - service: openvpn_service
    - require:
      - file: openvpn_auth_pam
{%- endif %}
{%- endif %}

{%- endif %}
