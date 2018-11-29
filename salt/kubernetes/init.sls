include:
  - docker
  - swap.disable
  - kubernetes.repo


{% if salt.grains.get('os', 'false') == 'Raspbian' %}
{% set rootpartition = salt['cmd.shell']("grep -Po 'PARTUUID=[0-9|a-z]+-[0-9|a-z]+ ' /boot/cmdline.txt") %}
raspbery_pi_boot_cmdline:
  file.managed:
    - contents: dwc_otg.lpm_enable=0 console=serial0,115200 console=tty1 root={{ rootpartition }} rootfstype=ext4 elevator=deadline fsck.repair=yes rootwait cgroup_enable=cpuset cgroup_memory=1 cgroup_enable=memory
    - name: /boot/cmdline.txt
    - backup: minion
    - require:
      - cmd: disable_swap

system.reboot:
  module.run:
    - onchanges:
      - file: /boot/cmdline.txt

{% endif %}


kubernetes_packages:
  pkg.installed:


#docker_boostraper_download
#disable_swap
