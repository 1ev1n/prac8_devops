# Kubernetes манифесты

Эта директория содержит YAML файлы для развертывания приложения в Kubernetes.

## Файлы

- `namespace.yaml` - Создает namespace `todo-app` для изоляции ресурсов
- `mongodb-deployment.yaml` - Развертывание MongoDB с Service
- `todo-api-deployment.yaml` - Развертывание REST API приложения с Service

## Порядок развертывания

1. Сначала создайте namespace:
   ```bash
   kubectl apply -f namespace.yaml
   ```

2. Затем разверните MongoDB:
   ```bash
   kubectl apply -f mongodb-deployment.yaml -n todo-app
   ```

3. И наконец, разверните приложение:
   ```bash
   kubectl apply -f todo-api-deployment.yaml -n todo-app
   ```

## Важно

Перед развертыванием обновите `todo-api-deployment.yaml`:
- Замените `YOUR_DOCKERHUB_USERNAME` на ваш реальный username в Docker Hub

