set -e

kubectl apply -f secrets/prod/dockerconfigjson.yaml
kubectl apply -f secrets/prod/kafka.yaml
kubectl apply -f secrets/prod/postgres-community.yaml
kubectl apply -f secrets/prod/postgres-user.yaml
kubectl apply -f secrets/prod/postgres-image.yaml
kubectl apply -f secrets/prod/cognito.yaml
kubectl apply -f secrets/prod/aws.yaml
kubectl apply -f secrets/prod/image_service.yaml

flux check --pre

flux bootstrap github \
  --owner=$GITHUB_USER \
  --repository=otto-infra \
  --branch=main \
  --path=./clusters/prod \
  --personal
