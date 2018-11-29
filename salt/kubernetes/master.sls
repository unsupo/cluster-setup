include:
  - kubernetes.repo
  - swap.disable
  - docker

kubernetes_master_pkgs:
  pkg.installed:
    - pkgs:
      - kubeadm
    - require:
      - cmd: kubernetes_repository
      - cmd: disable_swap
      - cmd: docker_boostraper_run

{% set CIDR = 'weavenet' %}
# Optionally also pass --apiserver-advertise-address=192.168.0.27 with the IP of the Pi as found by typing ifconfig

# Sometimes this stage can fail, if it does then you should patch the API Server to allow for a higher failure threshold during initialization around the time you see [controlplane] wrote Static Pod manifest for component kube-apiserver to "/etc/kubernetes/manifests/kube-apiserver.yaml"
# sudo sed -i 's/failureThreshold: 8/failureThreshold: 20/g' /etc/kubernetes/manifests/kube-apiserver.yaml

kubernetes_master_CIDR:
  cmd.run:
    {% if CIDR == 'weavenet' %}
    - name: sudo kubeadm init --token-ttl=0 --ignore-preflight-errors=SystemVerification > /root/init.out
    {% elif CIDR == 'flannel' %}
    - name: sudo kubeadm init --token-ttl=0 --pod-network-cidr=10.244.0.0/16 > /root/init.out
    {% endif %}
    - creates: /root/init.out
    - require:
      - pkg: kubernetes_master_pkgs

kubernetes_master_init:
  cmd.run:
    - name:  mkdir -p /root/.kube && sudo cp -i /etc/kubernetes/admin.conf /root/.kube/config && sudo chown $(id -u):$(id -g) /root/.kube/config && echo 'DONE' > /root/init_01.out
    - require:
      - cmd: kubernetes_master_CIDR
    - creates: /root/init_01.out
