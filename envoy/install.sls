{% set install = {'from': 'docker', 'version': '1.11.2',} %}
{{ install.update(pillar.get('envoy', {}).get('install', {})) }}

{% if install['from'] == 'docker' %}
Pull Envoy container:
  cmd.run:
    - name: "docker pull envoyproxy/envoy:v{{ install['version'] }}"
    - unless: "docker images | grep envoyproxy | grep v{{ install['version'] }}"
{% else %}
# TODO: install via 'get-envoy' package
{% endif %}
