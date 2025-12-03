{% if pillar.get('demo_app') %}

{% set k3s_install_script = 'https://get.k3s.io' %}
{% set k3s_binary = '/usr/local/bin/k3s' %}
{% set kubeconfig_k3s = '/etc/rancher/k3s/k3s.yaml' %}
{% set kubeconfig_default = '/root/.kube/config' %}
{% set kubeconfig_default_dir = '/root/.kube' %}

# 1. Install necessary dependencies (e.g., curl, needed for the installer script)
k3s_prerequisites:
  pkg.installed:
    - pkgs:
      - curl
      - helm

# 2. Install K3s (Server Mode) if the binary is NOT present
k3s_install_server:
  cmd.run:
    - name: "curl -sfL {{ k3s_install_script }} | INSTALL_K3S_VERSION=v1.33.6+k3s1 sh -"
    # The 'unless' condition checks for the main K3s executable.
    # If the file exists, the installation command will be skipped.
    - unless: test -f {{ k3s_binary }}


# 3. Ensure K3s is running
# The K3s installation script sets up a systemd service, so we just check on it.
k3s_service_running:
  service.running:
    - name: k3s
    # This ensures the service management is only attempted if the installation was successful.
    - require:
      - cmd: k3s_install_server

ensure_kubeconfig_path:
  file.directory:
    - name: {{ kubeconfig_default_dir }}
    - user: root
    - group: root
    - mode: '700'
    - require:
      - service: k3s_service_running
      
kubeconfig_symlink:
  file.symlink:
    - name: {{ kubeconfig_default }}
    - target: {{ kubeconfig_k3s }}
    - force: True # Ensures it overwrites any existing file at the destination
    - require:
      - file: ensure_kubeconfig_path

helm_release_is_present:
  helm.release_present:
    - name: demo-release
    - chart: {{pillar['demo_app']['helm']['repo']}}
    - version: {{pillar['demo_app']['helm']['version']}}
    - set:
       - ingress.host={{ salt['grains.get']('fqdn') | lower }} # <-- This is THE Machine FQDN
       - image.tag={{pillar['demo_app']['image']['tag']}}
       - image.repository={{pillar['demo_app']['image']['repository']}}
    - require:
        - pkg: helm
        - service: k3s_service_running

 {% endif %}