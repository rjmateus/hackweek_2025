Simple Alpine Web Server

This project creates a minimal Docker image based on nginx:alpine to serve a static "Hello, World!" HTML page.

Files

index.html: The static content.

Dockerfile: The instructions for building the image.

Instructions

1. Build the Docker Image

Run the following command in the same directory as the Dockerfile and index.html. The image will be tagged as simple-web.

podman build -t simple-web .


2. Run the Container

Once the image is built, run the container, mapping the container's port 80 to your host machine's port 8080:

podman run --rm -p 8080:80 --name simple-server simple-web


3. View the Website

You can now view the "Hello, World!" page by navigating to:

http://localhost:8080

4. Stop and Remove the Container

When you are finished, you can stop and remove the container:

podman stop simple-server
podman rm simple-server


5. Publish the Image (Docker Hub Example)

To prepare the image for deployment in environments like Kubernetes, you need to publish it to a public registry like Docker Hub or a private registry (like Google Container Registry, AWS ECR, etc.).

Note: Replace [YOUR_DOCKERHUB_USERNAME] with your actual Docker Hub ID.

A. Tag the Image

You must tag the image with the registry path (<username>/<repository>:<tag>). This links your local image to the remote repository.

docker tag simple-web [YOUR_DOCKERHUB_USERNAME]/simple-web:v1


B. Log in to the Registry

Log into your Docker registry account (if you haven't already).

podman login registry-1.docker.io

# Enter your username and password when prompted.


C. Push the Image

Push the newly tagged image to the remote registry. This is the fully qualified image name you will reference in your Kubernetes deployment file.

podman push [YOUR_DOCKERHUB_USERNAME]/simple-web:v1
