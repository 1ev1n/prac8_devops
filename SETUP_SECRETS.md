# Настройка секретов GitHub для CI/CD

## Шаг 1: Добавление секретов в GitHub

1. Перейдите в ваш репозиторий: https://github.com/1ev1n/prac8_devops
2. Откройте **Settings** → **Secrets and variables** → **Actions**
3. Нажмите **New repository secret**

### Добавьте следующие секреты:

#### 1. DOCKERHUB_USERNAME
- **Имя:** `DOCKERHUB_USERNAME`
- **Значение:** `1ev1n`

#### 2. DOCKERHUB_TOKEN
- **Имя:** `DOCKERHUB_TOKEN`
- **Значение:** `ВАШ_ТОКЕН_DOCKER_HUB` (используйте ваш токен доступа)

#### 3. KUBECONFIG (опционально, только если нужно автоматическое развертывание в Kubernetes)
- **Имя:** `KUBECONFIG`
- **Значение:** (получите командой ниже)

## Шаг 2: Получение KUBECONFIG (для автоматического развертывания)

Если у вас установлен Minikube или другой Kubernetes кластер:

```bash
# Для Minikube
minikube kubectl config view --flatten | base64

# Для других кластеров (Linux/Mac)
cat ~/.kube/config | base64

# Для Windows (PowerShell)
[Convert]::ToBase64String([System.IO.File]::ReadAllBytes("$env:USERPROFILE\.kube\config"))
```

Скопируйте результат и добавьте как секрет `KUBECONFIG` в GitHub.

## Шаг 3: Проверка работы

После добавления секретов:
1. Сделайте любой коммит и push в ветку `main`
2. Перейдите в **Actions** в вашем репозитории
3. Вы увидите запущенный workflow "CI/CD Pipeline"
4. Workflow автоматически:
   - Соберет Docker образ
   - Отправит его в Docker Hub как `1ev1n/todo-api:latest`
   - Развернет в Kubernetes (если настроен KUBECONFIG)

## Важно!

⚠️ **НЕ КОММИТЬТЕ ТОКЕН В РЕПОЗИТОРИЙ!** Токен должен быть только в секретах GitHub.

