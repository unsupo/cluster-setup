include:
  - kubernetes.repo

kubernetes_kubectl_pkgs:
  pkg.installed:
    - pkgs:
      - kubelet
    - require:
      - pkgrepo: kubernetes_repository
