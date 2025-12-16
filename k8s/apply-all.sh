#!/bin/bash

# Применение всех Kubernetes манифестов

echo "Применение всех манифестов Kubernetes..."

kubectl apply -f namespace.yaml
kubectl apply -f mongodb-deployment.yaml -n todo-app
kubectl apply -f todo-api-deployment.yaml -n todo-app

echo "Готово! Проверьте статус:"
echo "kubectl get pods -n todo-app"

