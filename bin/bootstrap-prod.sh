set -e

flux check --pre

flux bootstrap github \
  --owner=danielmunro \
  --repository=otto-infra \
  --branch=main \
  --path=./clusters/prod \
  --personal