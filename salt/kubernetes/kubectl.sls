include:
  - kubernetes.repo

kubernetes_kubectl_pkgs:
  pkg.installed:
    - pkgs:
      - kubectl
    - require:
      - pkgrepo: kubernetes_repository
