{% set install = {'from': 'docker', 'version': '1.11.2'} %}
{% do install.update(pillar.get('envoy', {}).get('install', {})) %}

{% if install['from'] == 'docker' %}
Pull Envoy container:
  cmd.run:
    - name: "docker pull envoyproxy/envoy:v{{ install['version'] }}"
    - unless: "docker images | grep envoyproxy | grep v{{ install['version'] }}"

Create /var/log/envoy:
  file.directory:
    - name: /var/log/envoy
    - user: root
    - group: root
    - dir_mode: 755
    - file_mode: 644
{% else %}
Add Get-Envoy Repository:
  pkgrepo.managed:
    - humanname: Get-Envoy PPA
    - name: deb [arch=amd64] https://dl.bintray.com/tetrate/getenvoy-deb xenial stable
    - dist: xenial
    - file: /etc/apt/sources.list.d/get-envoy.list
    - gpgcheck: 1
    - key_url: https://getenvoy.io/gpg

Install Envoy from Get-Envoy:
  pkg.installed:
    - name: getenvoy-envoy
    - version: {{ install['version'] }}
{% endif %}
