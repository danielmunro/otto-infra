# otto-infra

Prerequisites: `kind`, `kubectl`, `flux`

## Cluster Setup

```
kind create cluster --config config/dev/cluster-config.yaml

# apply ingress patches for local cluster
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml

# wait for ready
kubectl wait --namespace ingress-nginx \
  --for=condition=ready pod \
  --selector=app.kubernetes.io/component=controller \
  --timeout=90s

# create ingress  
kubectl apply -f config/dev/ingress-nginx.yaml

# secrets
kubectl apply -f secrets/dev/dockerconfigjson.yaml
kubectl apply -f secrets/dev/kafka.yaml
kubectl apply -f secrets/dev/postgres-community.yaml
kubectl apply -f secrets/dev/postgres-user.yaml
kubectl apply -f secrets/dev/postgres-image.yaml
kubectl apply -f secrets/dev/cognito.yaml
kubectl apply -f secrets/dev/aws.yaml
kubectl apply -f secrets/dev/image-service.yaml
```

## Install FluxCD

```
# check
flux check --pre

# install
flux bootstrap github \
  --owner=$GITHUB_USER \
  --repository=otto-infra \
  --branch=main \
  --path=./clusters/dev \
  --personal
  
# check
flux get kustomizations
```

## Cleaning Up

```
kind delete cluster --name kind
```
