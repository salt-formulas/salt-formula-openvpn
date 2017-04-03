{% from "openvpn/map.jinja" import client with context %}
{%- if client.enabled %}

include:
- openvpn.common

/etc/default/openvpn:
  file.managed:
  - source: salt://openvpn/files/default
  - template: jinja
  - mode: 600
  - require:
    - pkg: openvpn_packages
  {%- if not grains.get('noservices', False) %}
  - watch_in:
    - service: openvpn_service
  {%- endif %}

{%- for tunnel_name, tunnel in client.tunnel.iteritems() %}

/etc/openvpn/{{ tunnel_name }}.conf:
  file.managed:
    - source: salt://openvpn/files/client.conf
    - template: jinja
    - mode: 600
    - default:
      tunnel_name: '{{ tunnel_name }}'
    - require:
      - pkg: openvpn_packages
    {%- if not grains.get('noservices', False) %}
    - watch_in:
      - service: openvpn_service
    {%- endif %}

{%- if tunnel.ssl.get('engine', 'default') == 'default' %}

/etc/openvpn/ssl/{{ tunnel.ssl.authority }}_{{ tunnel.ssl.certificate }}.crt:
  file.managed:
  - source: salt://pki/{{ tunnel.ssl.authority }}/certs/{{ tunnel.ssl.certificate }}.cert.pem
  - require:
    - file: openvpn_ssl_dir
  {%- if not grains.get('noservices', False) %}
  - require_in:
    - service: openvpn_service
  {%- endif %}

/etc/openvpn/ssl/{{ tunnel.ssl.authority }}_{{ tunnel.ssl.certificate }}.key:
  file.managed:
  - source: salt://pki/{{ tunnel.ssl.authority }}/certs/{{ tunnel.ssl.certificate }}.key.pem
  - require:
    - file: openvpn_ssl_dir
  {%- if not grains.get('noservices', False) %}
  - require_in:
    - service: openvpn_service
  {%- endif %}

/etc/openvpn/ssl/{{ tunnel.ssl.authority }}.crt:
  file.managed:
  - source: salt://pki/{{ tunnel.ssl.authority }}/{{ tunnel.ssl.authority }}-chain.cert.pem
  - require:
    - file: openvpn_ssl_dir
  {%- if not grains.get('noservices', False) %}
  - require_in:
    - service: openvpn_service
  {%- endif %}

{%- endif %}

{%- endfor %}

{%- endif %}