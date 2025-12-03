get app demo:
  cmd.run:
     - name: kubectl get ingress demo-app


Helm status:
  cmd.run:
     - name: helm status demo-release

#helm:
#  pkg.installed

helm_release_is_present:
  helm.release_present:
    - name: demo-release
    - chart: oci://registry-1.docker.io/rjmateus/demo-app
    - version: 0.0.1
#  - require:
#      - pkg: helm