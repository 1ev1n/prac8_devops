# Быстрая настройка GitHub Actions

## Шаг 1: Добавление секретов в GitHub (ОБЯЗАТЕЛЬНО!)

1. Перейдите: https://github.com/1ev1n/prac8_devops/settings/secrets/actions
2. Нажмите **"New repository secret"** для каждого секрета:

### Секрет 1: DOCKERHUB_USERNAME
- **Name:** `DOCKERHUB_USERNAME`
- **Secret:** `1ev1n`
- Нажмите **"Add secret"**

### Секрет 2: DOCKERHUB_TOKEN
- **Name:** `DOCKERHUB_TOKEN`
- **Secret:** `ВАШ_ТОКЕН_DOCKER_HUB` (используйте токен, который вам предоставили)
- Нажмите **"Add secret"**

## Шаг 2: Проверка workflow

После добавления секретов:
1. Перейдите в **Actions** в вашем репозитории
2. Сделайте любой коммит (или просто откройте Actions)
3. Workflow должен автоматически запуститься при push в `main`

## Шаг 3: Что делает workflow

При каждом push в ветку `main`:
- ✅ Собирает Docker образ из Dockerfile
- ✅ Отправляет образ в Docker Hub как `1ev1n/todo-api:latest`
- ✅ (Опционально) Развертывает в Kubernetes, если настроен KUBECONFIG

## Проверка работы

1. Откройте: https://github.com/1ev1n/prac8_devops/actions
2. Выберите последний workflow run
3. Проверьте, что все шаги выполнены успешно (зеленые галочки)

## Если workflow не запускается

1. Убедитесь, что секреты добавлены правильно
2. Проверьте, что вы делаете push в ветку `main` или `master`
3. Проверьте логи в разделе Actions

