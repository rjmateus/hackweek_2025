# hackweek_2025


## Machine provisioning
> Deploy sle-micro 6.1 machine with the GM image, to have updates available
> install helm `transactional-update pkg install helm`
> install an older version for k3s: `curl -sfL https://get.k3s.io | INSTALL_K3S_VERSION=v1.33.6+k3s1 sh -`
> install k9s: 
    - cd ~
    - curl -LO https://github.com/derailed/k9s/releases/download/v0.50.6/k9s_Linux_amd64.tar.gz
    - tar -xzf k9s_Linux_amd64.tar.gz
    - sudo mv k9s /usr/local/bin/
    - sudo chmod +x /usr/local/bin/k9s
    - k9s version
    - vi ~/.bashrc
        - `export KUBECONFIG=/etc/rancher/k3s/k3s.yaml`
    - source .bashrc 

A this stage the only missing part is confirm DNS and Machine name

## Deploy application

In the first day I'm deplying the application to make sure all the bits are in-place.
See decicated readme on the helm sub-folder to see how to do it.

## Register to MLM

On the server, generated the bootstrap script: https://documentation.suse.com/multi-linux-manager/5.1/en/docs/client-configuration/registration-bootstrap.html#_create_a_bootstrap_script_from_webui

In the machine run `curl --insecure https://<SERVER_FQDN>/pub/bootstrap/bootstrap.sh | bash -

Go the the MLM server ans accept the salt key. The process should finish with the machine fulle registered.


# Application deployment and Update with MLM

We will be using MLM to set wich version should be deployed (using salt pillars) and how to deploy it (using salt states).
The plan is to be flexible mechanism to allow user to define which version should be deploy with different levels of granularity. For example, a global version, a version at store level or even a version at terminal level.

This will allow users to have canary deployments, and controlled roll-out.

Pillar definition can be done using different machine caracterists, and the data can be overwrite at different levels. We will be laveraging the top.sls.

- Assuming naming convention:
    - US01-S001-T001-N0 - machine deployed
    - US01-S001-T002-N0
    - US01-S001-T003-N0
    - US01-S001-T003-N1

where: 
    "US01" -> region
    "S001" -> store number
    "T001" -> terminal number
    "N0" -> termonal node number


On MLM UI create a system group for each store, and and assign the machines to this group.
Use this group ID to match the pillar data to be applied in the store.
Assign a configuration channel for the application deployment on the MLM web UI.
The pillar and states data can be seem in the salt sub-folder.

*** Problems *** 
- By using MLM group pillar assignement means we must have a entry on the top.sls file for each store/group. It can make the top SLS grow a lot (2 lines per store) and have one sub-folder (or sls file) per store.
- Adding a new store means:
    - create MLM system group
    - Update top.sls file
    - assign machines to the group


## MLM configuration channel

Create a salt configuration channel which the only thing it does is include the state defined on git.



# Alternative solution for pillar and state assign

Develop an use a salt formula that would allow us to assign the pillar information and salt state to each system and system group.
This swifts the infrastructure management from gitops to fully integrated with MLM. The formula definition is how costumer currently manage retail deployment based on image (pxed booting) on MLM/uyuni.