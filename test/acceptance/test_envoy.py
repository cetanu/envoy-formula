def test_envoy_service_file(host):
    file = host.file('/etc/systemd/system/envoy.service')
    assert file.exists
