# Настройка GitHub для CI/CD

Это руководство поможет настроить автоматическое развертывание через GitHub Actions.

## Шаг 1: Создание репозитория на GitHub

1. Перейдите на [GitHub](https://github.com)
2. Создайте новый репозиторий (например, `cd`)
3. Не добавляйте README, .gitignore или лицензию (они уже есть в проекте)

## Шаг 2: Инициализация Git и загрузка кода

```bash
# Инициализация Git (если еще не сделано)
git init

# Добавление всех файлов
git add .

# Первый коммит
git commit -m "Initial commit: Практическая работа №8.1"

# Добавление remote репозитория (замените YOUR_USERNAME и REPO_NAME)
git remote add origin https://github.com/YOUR_USERNAME/REPO_NAME.git

# Загрузка кода
git branch -M main
git push -u origin main
```

## Шаг 3: Настройка секретов в GitHub

### 3.1. Получение токена Docker Hub

1. Войдите в [Docker Hub](https://hub.docker.com)
2. Перейдите в Account Settings → Security → New Access Token
3. Создайте токен с правами на чтение/запись
4. Сохраните токен (он показывается только один раз!)

### 3.2. Получение kubeconfig

**Для Minikube:**
```bash
# Получить kubeconfig и закодировать в base64
minikube kubectl config view --flatten | base64
```

**Для других кластеров:**
```bash
# Linux/Mac
cat ~/.kube/config | base64

# Windows (PowerShell)
[Convert]::ToBase64String([System.IO.File]::ReadAllBytes("$env:USERPROFILE\.kube\config"))
```

### 3.3. Добавление секретов в GitHub

1. Перейдите в ваш репозиторий на GitHub
2. Откройте **Settings** → **Secrets and variables** → **Actions**
3. Нажмите **New repository secret**
4. Добавьте следующие секреты:

| Имя секрета | Значение | Описание |
|------------|----------|----------|
| `DOCKERHUB_USERNAME` | Ваш username в Docker Hub | Например: `myusername` |
| `DOCKERHUB_TOKEN` | Токен доступа Docker Hub | Токен, полученный в шаге 3.1 |
| `KUBECONFIG` | Закодированный kubeconfig | Результат команды из шага 3.2 |

## Шаг 4: Обновление манифестов Kubernetes

Перед первым развертыванием обновите файл `k8s/todo-api-deployment.yaml`:

1. Откройте `k8s/todo-api-deployment.yaml`
2. Найдите строку: `image: YOUR_DOCKERHUB_USERNAME/todo-api:latest`
3. Замените `YOUR_DOCKERHUB_USERNAME` на ваш реальный username в Docker Hub
4. Сохраните и закоммитьте изменения:

```bash
git add k8s/todo-api-deployment.yaml
git commit -m "Update Docker image name in deployment"
git push
```

## Шаг 5: Проверка работы CI/CD

После настройки секретов:

1. Сделайте любой коммит и push в ветку `main` или `master`
2. Перейдите в **Actions** в вашем репозитории
3. Вы увидите запущенный workflow "CI/CD Pipeline"
4. Workflow выполнит:
   - Сборку Docker образа
   - Отправку образа в Docker Hub
   - Развертывание в Kubernetes

## Шаг 6: Проверка развертывания

После успешного выполнения workflow:

```bash
# Проверить статус подов
kubectl get pods -n todo-app

# Проверить сервисы
kubectl get services -n todo-app

# Просмотреть логи приложения
kubectl logs -f deployment/todo-api-deployment -n todo-app
```

## Решение проблем

### Workflow не запускается

- Убедитесь, что файл `.github/workflows/ci-cd.yml` существует
- Проверьте, что вы делаете push в ветку `main` или `master`

### Ошибка при сборке Docker образа

- Проверьте, что `DOCKERHUB_USERNAME` и `DOCKERHUB_TOKEN` правильно настроены
- Убедитесь, что токен имеет права на запись

### Ошибка при развертывании в Kubernetes

- Проверьте, что `KUBECONFIG` правильно закодирован в base64
- Убедитесь, что кластер Kubernetes доступен
- Проверьте логи workflow в разделе Actions

### Приложение не может подключиться к MongoDB

- Убедитесь, что MongoDB развернут: `kubectl get pods -n todo-app`
- Проверьте, что Service для MongoDB создан: `kubectl get svc -n todo-app`
- Проверьте логи приложения: `kubectl logs deployment/todo-api-deployment -n todo-app`

## Дополнительные настройки

### Настройка для других веток

По умолчанию workflow запускается только для `main` и `master`. Чтобы изменить это, отредактируйте `.github/workflows/ci-cd.yml`:

```yaml
on:
  push:
    branches: [ main, master, develop ]  # Добавьте нужные ветки
```

### Использование тегов для версионирования

Можно настроить автоматическое создание тегов при релизах. Добавьте в workflow:

```yaml
- name: Create tag
  if: startsWith(github.ref, 'refs/tags/')
  run: |
    TAG=${GITHUB_REF#refs/tags/}
    docker tag ${{ secrets.DOCKERHUB_USERNAME }}/todo-api:latest \
      ${{ secrets.DOCKERHUB_USERNAME }}/todo-api:$TAG
    docker push ${{ secrets.DOCKERHUB_USERNAME }}/todo-api:$TAG
```

## Полезные ссылки

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Docker Hub Documentation](https://docs.docker.com/docker-hub/)
- [Kubernetes Documentation](https://kubernetes.io/docs/home/)

