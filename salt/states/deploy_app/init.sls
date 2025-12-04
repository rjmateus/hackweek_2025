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

# 2. set k3s Configuration

{% set k3s_config = salt['pillar.get']('k3s:config', {}) %}

k3s_config_dir:
  file.directory:
    - name: /etc/rancher/k3s
    - user: root
    - group: root
    - mode: 755
    - makedirs: True

k3s_config_file:
  file.managed:
    - name: /etc/rancher/k3s/config.yaml
    - source: salt://deploy_app/config.yaml.jinja  # Path to your template file
    - user: root
    - group: root
    - mode: 600
    - template: jinja
    - defaults:
        server: {{ k3s_config.get('server', None) }}
        token: {{ k3s_config.get('token', None) }}
        cluster_init: {{ k3s_config.get('cluster-init', False) }}
        tls_san_list: {{ k3s_config.get('tls-san', []) | lower }}
    - require:
      - file: k3s_config_dir


{% set k3s_version = "" %}

{% if pillar['k3s_version'] is defined %}
  {% set k3s_version_install = "INSTALL_K3S_VERSION=" + salt['pillar.get']('k3s_version', "") %}
{% endif %}


# 3. Install K3s (Server Mode) if the binary is NOT present
k3s_install_server:
  cmd.run:
    - name: "curl -sfL {{ k3s_install_script }} | {{ k3s_version_install }} sh -"
    # The 'unless' condition checks for the main K3s executable.
    # If the file exists, the installation command will be skipped.
    - unless: test -f {{ k3s_binary }}
    - require:
      - file: k3s_config_file


# 4. Ensure K3s is running
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

helm:
  pkg.installed

## deploy update controller

#{% if salt['pillar.get']('k3s:config:server', None) is none %}

install_update_controller:
   cmd.run:
     - name: kubectl apply -f https://github.com/rancher/system-upgrade-controller/releases/latest/download/crd.yaml -f https://github.com/rancher/system-upgrade-controller/releases/latest/download/system-upgrade-controller.yaml


update_controler_plan:
  file.managed:
    - name: /etc/rancher/k3s/k3s-upgrade-plans.yaml
    - source: salt://deploy_app/k3s-upgrade-plans.yaml.jinja  # Path to your template file
    - user: root
    - group: root
    - mode: 600
    - template: jinja
    - defaults:
        k3s_version: {{ k3s_config.get('k3s_version', None) }}
    - require:
      - file: k3s_config_dir
      - cmd: install_update_controller

deploy_upgrade_plan:
   cmd.run:
      - name: kubectl apply -f /etc/rancher/k3s/k3s-upgrade-plans.yaml

#{% endif %}

## deploy demo app
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