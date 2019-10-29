def test_envoy_service_file(host):
    file = host.file('/etc/systemd/system/envoy.service')
    assert file.exists


def test_envoy_binary(host):
    binary = host.file('/usr/bin/envoy')
    assert binary.exists
    assert binary.mode == 0o755
    cmd = host.run('/usr/bin/envoy --version')
    assert cmd.succeeded
    assert cmd.stdout == 'bleh'
