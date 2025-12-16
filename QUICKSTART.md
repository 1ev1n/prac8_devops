# Быстрый старт

Краткое руководство по запуску проекта.

## 🚀 Быстрый запуск с Docker Compose

```bash
docker-compose up -d
```

Приложение будет доступно на `http://localhost:3000`

## 📦 Развертывание в Kubernetes

### Предварительные требования

- [Minikube](https://minikube.sigs.k8s.io/docs/start/) установлен и запущен
- [kubectl](https://kubernetes.io/docs/tasks/tools/) установлен

### Шаги

1. **Запустите Minikube:**
   ```bash
   minikube start
   ```

2. **Обновите Docker image в манифесте:**
   - Откройте `k8s/todo-api-deployment.yaml`
   - Замените `YOUR_DOCKERHUB_USERNAME` на ваш username

3. **Разверните приложение:**
   ```bash
   # Windows
   deploy.bat
   
   # Linux/Mac
   chmod +x deploy.sh
   ./deploy.sh
   ```

4. **Получите доступ к приложению:**
   ```bash
   minikube service todo-api-service -n todo-app
   ```

## 🔄 CI/CD с GitHub Actions

1. Создайте репозиторий на GitHub
2. Настройте секреты (см. [GITHUB_SETUP.md](GITHUB_SETUP.md))
3. Загрузите код:
   ```bash
   git init
   git add .
   git commit -m "Initial commit"
   git remote add origin https://github.com/YOUR_USERNAME/REPO_NAME.git
   git push -u origin main
   ```

## 🧪 Тестирование API

```bash
# Health check
curl http://localhost:3000/health

# Создать задачу
curl -X POST http://localhost:3000/todos \
  -H "Content-Type: application/json" \
  -d '{"title": "Тест", "description": "Описание"}'

# Получить все задачи
curl http://localhost:3000/todos
```

Подробные примеры: [API_EXAMPLES.md](API_EXAMPLES.md)

## 📚 Документация

- [README.md](README.md) - Полная документация
- [API_EXAMPLES.md](API_EXAMPLES.md) - Примеры использования API
- [GITHUB_SETUP.md](GITHUB_SETUP.md) - Настройка CI/CD
- [k8s/README.md](k8s/README.md) - Описание Kubernetes манифестов

## ⚠️ Важные замечания

1. Перед развертыванием в Kubernetes обновите `YOUR_DOCKERHUB_USERNAME` в `k8s/todo-api-deployment.yaml`
2. Для CI/CD настройте секреты в GitHub (см. GITHUB_SETUP.md)
3. Убедитесь, что MongoDB развернут перед запуском приложения

## 🆘 Помощь

При возникновении проблем:
1. Проверьте логи: `kubectl logs -f deployment/todo-api-deployment -n todo-app`
2. Проверьте статус подов: `kubectl get pods -n todo-app`
3. См. раздел "Решение проблем" в [README.md](README.md)

