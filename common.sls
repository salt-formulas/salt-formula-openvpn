{% from "openvpn/map.jinja" import common with context %}

openvpn_packages:
  pkg.installed:
  - names: {{ common.pkgs }}

openvpn_service:
  service.runnig:
  - name: {{ common.service }}
