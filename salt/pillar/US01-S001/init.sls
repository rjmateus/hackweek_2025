demo_app:
    image:
        repository: rjmateus/hw2025
        tag: 1.0.0
    helm: 
        repo: oci://registry-1.docker.io/rjmateus/demo-app
        version: 0.0.1
    replicaCount: 3

## define the k3s version. In this case is the same for all terminal in the store.
## We can have another condition in here to control differente k3s versions in each terminal

k3s_version: v1.32.10+k3s1
# k3s_version: v1.33.6+k3s1
#k3s_version: v1.34.2+k3s1


{% set minion_id = grains['id'] %}

# Specific data for terminal 2
{% if minion_id.startswith('US01-S001-T002-N0') %}
k3s:
  config:
    control-plane: True
    cluster-init: True
    tls-san:
      - "US01-S001-T002-N0.suse.lab"
{% endif %}

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
###    server: None # Explicitly set to None for the cluster-init node
    tls-san:
      - "US01-S001-T003-N0.suse.lab"
    control-plane: True
{% else %}
{% if minion_id.startswith('US01-S001-T003-N1') %}
    agent: True    
{% endif %}
    # --- Agent Node Configuration ---
    cluster-init: False
    server: "https://us01-s001-t003-n0.suse.lab:6443"
    tls-san: [] # Agent nodes typically don't need SANs
    control-plane: False
{% endif %}

{% endif %}
