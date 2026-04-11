#!/usr/bin/env bash
set -euo pipefail

NS=apps-deployer

# PG_AUTH_PASSWORD=$(openssl rand -base64 32)
# PG_AUTH_ADMIN_PASSWORD=$(openssl rand -base64 32)
# PG_DEPLOYMENTS_PASSWORD=$(openssl rand -base64 32)
# PG_DEPLOYMENTS_ADMIN_PASSWORD=$(openssl rand -base64 32)
# PG_PROJECTS_PASSWORD=$(openssl rand -base64 32)
# PG_PROJECTS_ADMIN_PASSWORD=$(openssl rand -base64 32)
# REDIS_PASSWORD=$(openssl rand -base64 32)

apply_secret() {
  kubectl create secret "$@" --namespace "$NS" --dry-run=client -o yaml | kubectl apply -f -
}

echo "Applying secrets to namespace $NS..."

apply_secret generic postgres-auth-passwords \
  --from-literal=password="$PG_AUTH_PASSWORD" \
  --from-literal=admin-password="$PG_AUTH_ADMIN_PASSWORD"

apply_secret generic postgres-deployments-passwords \
  --from-literal=password="$PG_DEPLOYMENTS_PASSWORD" \
  --from-literal=admin-password="$PG_DEPLOYMENTS_ADMIN_PASSWORD"

apply_secret generic postgres-projects-passwords \
  --from-literal=password="$PG_PROJECTS_PASSWORD" \
  --from-literal=admin-password="$PG_PROJECTS_ADMIN_PASSWORD"

apply_secret generic redis-password \
  --from-literal=password="$REDIS_PASSWORD"
