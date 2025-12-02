https://documentation.suse.com/multi-linux-manager/5.1/en/docs/specialized-guides/salt/salt-gitfs.html

Add a file `/etc/salt/master.d/gitfs.conf` with:

```
fileserver_backend:
  - roots
  - git

gitfs_remotes:
  - https://github.com/rjmateus/hackweek_2025.git:
    - root: salt/states
    - base: main
```

> force gitfs update: 


Edit file: `/etc/salt/master.d/susemanager.conf`
```

```