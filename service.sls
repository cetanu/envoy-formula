{% set defaults = {'running': True, 'enabled': True, 'restart': True, 'reload': False} %}
{% set service = defaults.update(pillar.get('envoy', {}).get('service', {})) %}
{% set run_state = 'running' if service['running'] else 'stopped' %}
{% set service_files = {
  'systemd': '/etc/systemd/system/envoy.service',
  'initd': '/etc/init.d/envoy'
} %}

{% set defaults = {'from': 'docker', 'version': '1.11.2',} %}
{% set install = defaults.update(pillar.get('envoy', {}).get('install', {})) %}


{{ service_files[service['init_system']] }}:
  file.managed:
    - source: salt://static/envoy/systemd-envoy-{{ install['from'] }}

envoy-service:
  service.{{ run_state }}:
    - name: envoy
    - enable: {{ service['enabled'] }}
    - require:
      - sls: envoy.config
    - watch:
      - sls: envoy.config
    # In the event that both restart/reload are true, this will
    # simply set full_restart to true.
    {% if service['restart'] %}
    - full_restart: True
    {% elif service['reload'] %}
    - reload: True
    {% endif %}
