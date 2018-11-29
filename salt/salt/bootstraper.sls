
installer_download:
  file.managed:
    - source: https://bootstrap.saltstack.com
    - name: /root/install_salt.sh
    - skip_verify: True
