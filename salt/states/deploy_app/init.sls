get app demo:
  cmd.run:
     - name: kubectl get ingress demo-app


Helm status:
  cmd.run:
     - name: helm status demo-release

{% if pillar.get('demo_app') %}

#helm:
#  pkg.installed



helm_release_is_present:
  helm.release_present:
    - name: demo-release
    - chart: {{pillar['demo_app']['helm']['repo']}}
    {% if pillar.get('demo_app.helm.version') %}
    - version: {{pillar['demo_app']['helm']['version']}}
    {% endif %}   
#  - require:
#      - pkg: helm

 {% endif %}