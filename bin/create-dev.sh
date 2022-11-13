set -e

kind create cluster --config config/dev/cluster-config.yaml
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml

kubectl apply -f secrets/dev/dockerconfigjson.yaml
kubectl apply -f secrets/dev/backstage.yaml
kubectl apply -f secrets/dev/kafka.yaml
kubectl apply -f secrets/dev/postgres-community.yaml
kubectl apply -f secrets/dev/postgres-user.yaml
kubectl apply -f secrets/dev/postgres-image.yaml
kubectl apply -f secrets/dev/cognito.yaml
kubectl apply -f secrets/dev/aws.yaml
kubectl apply -f secrets/dev/image-service.yaml

sleep 5

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
