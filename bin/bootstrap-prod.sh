set -e

kubectl apply -f secrets/prod/dockerconfigjson.yaml

flux check --pre

flux bootstrap github \
  --owner=$GITHUB_USER \
  --repository=otto-infra \
  --branch=main \
  --path=./clusters/prod \
  --personal
