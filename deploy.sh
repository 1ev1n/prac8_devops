#!/bin/bash

# Скрипт для развертывания приложения в Kubernetes

echo "🚀 Начало развертывания приложения..."

# Проверка наличия kubectl
if ! command -v kubectl &> /dev/null; then
    echo "❌ kubectl не найден. Установите kubectl для продолжения."
    exit 1
fi

# Создание namespace
echo "📦 Создание namespace..."
kubectl apply -f k8s/namespace.yaml

# Развертывание MongoDB
echo "🍃 Развертывание MongoDB..."
kubectl apply -f k8s/mongodb-deployment.yaml -n todo-app

# Ожидание готовности MongoDB
echo "⏳ Ожидание готовности MongoDB..."
kubectl wait --for=condition=ready pod -l app=mongodb -n todo-app --timeout=300s

# Развертывание приложения
echo "🚀 Развертывание Todo API..."
kubectl apply -f k8s/todo-api-deployment.yaml -n todo-app

# Ожидание готовности приложения
echo "⏳ Ожидание готовности приложения..."
kubectl wait --for=condition=ready pod -l app=todo-api -n todo-app --timeout=300s

# Вывод статуса
echo ""
echo "✅ Развертывание завершено!"
echo ""
echo "📊 Статус подов:"
kubectl get pods -n todo-app
echo ""
echo "🌐 Сервисы:"
kubectl get services -n todo-app
echo ""
echo "Для доступа к приложению используйте:"
echo "  minikube service todo-api-service -n todo-app"
echo "  или"
echo "  kubectl port-forward service/todo-api-service 3000:3000 -n todo-app"

