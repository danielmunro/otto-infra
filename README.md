# otto-infra

## Cluster Setup

```
kind create cluster --config config/dev/cluster-config.yaml

# apply ingress patches for local cluster
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml
kubectl apply -f apps/dev/kafka.yaml
kubectl apply -f secrets/dev/dockerconfigjson.yaml

# wait for ready
kubectl wait --namespace ingress-nginx \
  --for=condition=ready pod \
  --selector=app.kubernetes.io/component=controller \
  --timeout=90s
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
```
