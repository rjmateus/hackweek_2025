# Publish the Image (Docker Hub Example)

A. Log in to the Registry

Log into your Docker registry account (if you haven't already).

`helm registry login registry-1.docker.io -u YOUR_DOCKERHUB_USERNAME`


B. package the helm chart

`helm package demo-app`


C. Push helmchart

`helm push demo-app-1.0.0.tgz oci://registry-1.docker.io/YOUR_DOCKERHUB_NAMESPACE`

# deploy application

## From source folder

`helm install demo-release demo-app`

## From remote publish registry

`helm install demo-release oci://registry-1.docker.io/rjmateus/demo-app --version 0.0.1 --set ingress.host=<HOST_NAME>`

Set the tag version to deploy:

`helm upgrade demo-release demo-app --set image.tag="0.0.2"`

# Check application is running

`kubectl get ingress demo-app`

or even better:

`helm status demo-release`

# upgrade application

## From source folder
`helm upgrade demo-release demo-app`

## From remote publish registry

`helm upgrade demo-release oci://registry-1.docker.io/rjmateus/demo-app --version 0.0.1 --set ingress.host=<HOST_NAME>`

