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
See decicated readme on the helm sub-folder to see how

## Register to MLM

On the server, generated the bootstrap script: https://documentation.suse.com/multi-linux-manager/5.1/en/docs/client-configuration/registration-bootstrap.html#_create_a_bootstrap_script_from_webui

In the machine run `curl --insecure https://<SERVER_FQDN>/pub/bootstrap/bootstrap.sh | bash -

Go the the MLM server ans acept the salt key. The process should finish.