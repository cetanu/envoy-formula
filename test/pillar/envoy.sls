envoy:
  install:
    from: docker
    version: 1.11.2
  service:
    enabled: yes
    restart: yes
    init_system: systemd
