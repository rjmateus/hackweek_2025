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

force gitfs update:
`salt-run fileserver.update`
`salt-run git_pillar.update`
`salt '*' saltutil.refresh_pillar`


Edit file: `/etc/salt/master.d/susemanager.conf`
```
# Configure external pillar
ext_pillar:
  - suma_minion: True
  - git:
    - main https://github.com/rjmateus/hackweek_2025.git:
      - root: salt/pillar

```