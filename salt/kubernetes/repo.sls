kubernetes_repository:
  cmd.run:
    - name: curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add - && echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list && sudo apt-get update -q
    - creates: /etc/apt/sources.list.d/kubernetes.list
  # pkgrepo.managed:
  #   - humanname: Kubernetes
  #   - name: deb https://apt.kubernetes.io/ kubernetes-xenial main
  #   - dist: stable
  #   - file: /etc/apt/sources.list.d/kubernetes.list
  #   - gpgcheck: 1
  #   - key_url: https://packages.cloud.google.com/apt/doc/apt-key.gpg
