get app demo:
  cmd.run:
     - name: kubectl get ingress demo-app


Helm status:
  cmd.run:
     - name: helm status demo-release

{% if pillars.get('demo_app') %}

#helm:
#  pkg.installed



helm_release_is_present:
  helm.release_present:
    - name: demo-release
    - chart: {{grains['demo_app']['helm']['repo']}}
    {% if pillars.get('demo_app.helm.version') %}
    - version: {{grains['demo_app']['helm']['version']}}
    {% endif %}   
#  - require:
#      - pkg: helm

 {% endif %}