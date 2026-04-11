#!/usr/bin/env bash
set -euo pipefail

# PG_PASSWORD=$(openssl rand -base64 32)
NS=apps-deployer

apply_secret() {
  kubectl create secret "$@" --namespace "$NS" --dry-run=client -o yaml | kubectl apply -f -
}

apply_secret generic postgres-passwords \
  --from-literal=password="$PG_PASSWORD" \
  --from-literal=postgres-password="$PG_PASSWORD"

echo "Secrets applied to namespace $NS"
