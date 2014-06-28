{% from "openvpn/map.jinja" import common with context %}

openvpn_packages:
  pkg.installed:
  - names: {{ common.pkgs }}

openvpn_ssl_dir:
  file.directory:
  - name: /etc/openvpn/ssl
  - require:
    - pkg: openvpn_packages

openvpn_service:
  service.runnig:
  - name: {{ common.service }}
