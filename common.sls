{% from "openvpn/map.jinja" import common with context %}

openvpn_packages:
  pkg.installed:
  - names: {{ common.pkgs }}

openvpn_ssl_dir:
  file.directory:
  - name: /etc/openvpn/ssl
  - require:
    - pkg: openvpn_packages

{%- if grains.os_family == "Arch" %}

{%- for tunnel_name, tunnel in client.tunnel.iteritems() %}

openvpn_service:
  service.running:
  - name: "{{ tunel_name }}.service"
  - enable: true

{%- endfor %}

{%- else %}
openvpn_service:
  service.running:
  - name: {{ common.service }}
  - enable: true
{%- endif %}
