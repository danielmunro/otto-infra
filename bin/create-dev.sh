set -e

kind create cluster --config config/dev/cluster-config.yaml
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml

kubectl apply -f apps/dev/kafka.yaml
kubectl apply -f apps/dev/postgres.yaml

kubectl apply -f secrets/dev/dockerconfigjson.yaml
kubectl apply -f secrets/dev/kafka.yaml
kubectl apply -f secrets/dev/postgres.yaml

kubectl wait --namespace ingress-nginx \
  --for=condition=ready pod \
  --selector=app.kubernetes.io/component=controller \
  --timeout=90s

flux check --pre

flux bootstrap github \
  --owner=$GITHUB_USER \
  --repository=otto-infra \
  --branch=main \
  --path=./clusters/dev \
  --personal
