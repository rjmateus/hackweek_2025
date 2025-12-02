# deploy application

> helm install demo-release demo-app

# check if the applicaiton is deployed
>kubectl get ingress demo-app

# upgrade application

> helm upgrade demo-release demo-app

Set the tag version to deploy:

> helm upgrade demo-release demo-app --set image.tag="0.0.3"