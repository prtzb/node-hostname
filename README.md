# Node-hostname Example Deployment

This repo contains an example of how to containerize a small node application along with IaC to deploy it on Kubernetes.

## Image build

Build locally with:

```bash
docker build .
```

Run locally with:

```bash
docker run -dit --name node-hostname -p 3000:3000 ghcr.io/prtzb/node-hostname/node-hostname:0.0.2
```



In `.github/workflows/docker-publish.yml` is a small pipeline which produces a new image on every release. The image is pushed to ghcr.io.

## Infrastructure

In `infra/` you'll find a Terraform module to deploy a basic Kubernetes cluster on Akamai/Linode.

```bash
# Get a token from Linode (refer to their docs on how to get one)
export LINODE_TOKEN=your_token_here

# Download dependencies
terraform init

# Plan and run
terraform plan
terraform apply

# Get kubeconfig
terraform output -raw kubeconfig | base64 -d > ~/.kube/linode.yaml

# Destroy
terraform destroy
```

## Kubernetes

In `k8s/` you'll find two example deployments.

`k8s/ingress/` contains an example on how to exose the application with https. It requires a cluster where Traefik ingress controller and cert-manager is already installed, as well as a DNS record pointing to the ingress IP.

`k8s/lb` contains a simpler example using Kubernetes's built in layer4 loadbalancer, exposing the application behind the loadbalancer's IP address. This is only http, but it should work on any cluster where `type: loadbalancer` is available.


```bash
# For clusters with traefik and cert-manager (https):
kubectl apply -k k8s/ingress
curl https://node-hostname.stage.linnaeus.dev # This will only work on my personal, local environment
```

```bash
# For clusters without traefik and cert-manager (no https):
kubectl apply -k k8s/lb

# Get service external ip
kubectl get service -n node-hostname node-hostname-service
```

## Todo

There are many things to consider before going to production. Here are some ideas:

- Docker
  - If image size is important, consider, mulistage build
  - Parameterize Dockerfile for more flexibility
- Github
  - Set repo permissions
- Terraform
  - Set up remote tfstate backend
  - Parameterize module by using tfvars
- Kubernetes
  - Configure proper cluster with ingress and certificate management
  - Set up some gitops CD, such as FluxCD or ArgoCD
  - Helmify or kustomize deployment to avoid hardcoded values in k8s manifests.
