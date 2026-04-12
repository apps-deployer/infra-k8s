# infra-k8s

Helmfile-конфигурация инфраструктурных компонентов платформы [apps-deployer](https://github.com/apps-deployer).

## Состав

| Компонент | Чарт | Назначение |
|---|---|---|
| Traefik | `traefik/traefik` | Ingress-контроллер с автоматическим TLS (Let's Encrypt) |
| PostgreSQL × 3 | `bitnami/postgresql` | Базы данных для projects-service, deployments-service, auth-service |
| Redis | `bitnami/redis` | Брокер задач для Celery-воркеров |

## Требования

- [helmfile](https://github.com/helmfile/helmfile)
- [helm](https://helm.sh)
- [kubectl](https://kubernetes.io/docs/tasks/tools/) с настроенным kubeconfig
- [yc CLI](https://cloud.yandex.ru/docs/cli/quickstart)

## Структура

```
helmfile.yaml          # декларация релизов
values/
  traefik.yaml
  postgresql-projects.yaml
  postgresql-deployments.yaml
  postgresql-auth.yaml
  redis.yaml
scripts/
  secrets.sh           # создание Kubernetes Secrets
.github/workflows/
  helmfile-apply.yml   # автодеплой при пуше в main
  apply-secrets.yml    # ручное обновление секретов
```

## Первичная настройка

### 1. Создать секреты в кластере

```bash
export PG_PROJECTS_PASSWORD=...
export PG_PROJECTS_ADMIN_PASSWORD=...
export PG_DEPLOYMENTS_PASSWORD=...
export PG_DEPLOYMENTS_ADMIN_PASSWORD=...
export PG_AUTH_PASSWORD=...
export PG_AUTH_ADMIN_PASSWORD=...
export REDIS_PASSWORD=...

bash scripts/secrets.sh
```

> Для генерации паролей раскомментируй строки с `openssl rand` в начале скрипта.

### 2. Применить чарты

```bash
helmfile apply
```

### 3. Проверить

```bash
kubectl get pods -n apps-deployer
kubectl get pods -n traefik
```

## CI/CD

Пайплайн `helmfile-apply` запускается автоматически при пуше в ветку `main`.

Пайплайн `apply-secrets` запускается вручную через GitHub Actions UI.

### Необходимые GitHub Secrets

| Secret | Описание |
|---|---|
| `YC_SA_KEY` | JSON-ключ сервисного аккаунта `ci-infra-sa` |
| `YC_CLUSTER_ID` | ID кластера Kubernetes |
| `PG_PROJECTS_PASSWORD` | Пароль пользователя БД projects-service |
| `PG_PROJECTS_ADMIN_PASSWORD` | Пароль суперпользователя PostgreSQL |
| `PG_DEPLOYMENTS_PASSWORD` | Пароль пользователя БД deployments-service |
| `PG_DEPLOYMENTS_ADMIN_PASSWORD` | Пароль суперпользователя PostgreSQL |
| `PG_AUTH_PASSWORD` | Пароль пользователя БД auth-service |
| `PG_AUTH_ADMIN_PASSWORD` | Пароль суперпользователя PostgreSQL |
| `REDIS_PASSWORD` | Пароль Redis |
