# hackweek_2025


# Machine provisioning (optinal)

## Micro 6.1
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

## sles15sp7

Download and deploy the image `SLES15-SP7-Minimal-VM.x86_64-Cloud-GM.qcow2`
Set the hostname with `hostnamectl set-hostname <HOSTNAME>`
Reboot (just in case)


# MLM configuration


## Configure GitFS

Configure GITFS. Look at `salt/readme.md`file to see how to set it up. 

## Create a state configuration channel

Add channel label `deploy_demo_app`. In the init.sls insert the following code:
```
include:
   - deploy_app
```

This will include the salt state defined in this git repository.

## Create activation key

In MLM create an activation-key with:
    - Sles15sp7 channels, including "Containers Module" wich is needed
    - If you want to automate application deployment at registration time:
        - Add the configuration channel `deploy_demo_app`
        - After creating the activation key select the checkbox `Deploy configuration files to systems on registration`

# Register machine to MLM

Before register the machine make sure to have the needed pillar information for the system in the pillar data.
If you are not sure about the pillar data, you can disable the deploy at registration time, and just register the machine, check the pillar data. The application deployment can done after registration (by assigning configuration channel, and apply the state).

Use the regular registration machanism and select the created activation key.


# Details at application deployment and Update with MLM

We will be using MLM to set wich version should be deployed (using salt pillars) and how to deploy it (using salt states).
The plan is to be flexible mechanism to allow user to define which version should be deploy with different levels of granularity. 
For example, a global version, a version at store level or even a version at terminal level.

This will allow users to have canary deployments, and controlled roll-out.

Pillar definition can be done using different machine caracterists (based on machine_id and grains), and the data can be overwrite at different levels.

Have a look at the salt/pillar subfolder

*** Problems *** 
- By using MLM group pillar assignement means we must have a entry on the top.sls file for each store/minion. It can make the top SLS grow a lot (2 lines per store) and have one sub-folder (or sls file) per store.
- Adding a new store means:
    - Update top.sls file to match the naming convention
    - Define the store/minion pillar data


## Naming convention

All large scale customer have some kind of naming convention to know which machine is where. In this example we will use the following naming convention.

- Assuming naming convention:
    - US01-S001-T001-N0 - machine deployed with sle micro 6.1
    - US01-S001-T002-N0 - sles15sp7
    - US01-S001-T003-N0 - sles15sp7
    - US01-S001-T003-N1 - sles15sp7
where: 
    "US01" -> region
    "S001" -> store number
    "T001" -> terminal number
    "N0" -> termonal node number


# Troubleshoting

Force data update

`salt-run fileserver.update`
`salt-run git_pillar.update`
`salt '<MINION_ID>' saltutil.refresh_pillar`

`salt '<MINION_ID>' saltutil.sync_all`


# Alternative solution for pillar and state assign

Develop an use a **salt formula** that would allow us to assign the pillar information and salt state to each system and system group.
This swifts the infrastructure management from gitops to fully integrated with MLM. The formula definition is how costumer currently manage retail deployment based on image (pxed booting) on MLM/uyuni.