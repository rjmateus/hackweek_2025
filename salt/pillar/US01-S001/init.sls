demo_app:
    image:
        repository: rjmateus/hw2025
        tag: 0.0.2
    helm: 
        repo: oci://registry-1.docker.io/rjmateus/demo-app
        version: 0.0.1

k3s.version: v1.32.10+k3s1

{% set minion_id = grains['id'] %}

# Specific data for terminal 3
{% if minion_id.startswith('US01-S001-T003') %}

k3s:
  config:
    id: {{minion_id}}
    # Set the token once for all nodes
    token: "token-for-US01-S001-T003"
{% if minion_id.startswith('US01-S001-T003-N0') %}

    # --- Primary Server Configuration ---
    cluster-init: True
    server: None # Explicitly set to None for the cluster-init node
    tls-san:
      - "US01-S001-T003-N0.suse.lab"
{% else %}
    # --- Agent Node Configuration ---
    cluster-init: False
    server: "https://us01-s001-t003-n0.suse.lab:6443"
    tls-san: [] # Agent nodes typically don't need SANs
{% endif %}

{% endif %}
