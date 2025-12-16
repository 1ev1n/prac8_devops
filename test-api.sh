#!/bin/bash

# Скрипт для тестирования API

API_URL=${1:-http://localhost:3000}

echo "🧪 Тестирование API по адресу: $API_URL"
echo ""

# Health check
echo "1. Health check..."
curl -s $API_URL/health | jq .
echo ""

# Создание задачи
echo "2. Создание новой задачи..."
TASK_RESPONSE=$(curl -s -X POST $API_URL/todos \
  -H "Content-Type: application/json" \
  -d '{"title": "Тестовая задача", "description": "Описание тестовой задачи"}')
echo $TASK_RESPONSE | jq .

TASK_ID=$(echo $TASK_RESPONSE | jq -r '._id')
echo ""
echo "Создана задача с ID: $TASK_ID"
echo ""

# Получение всех задач
echo "3. Получение всех задач..."
curl -s $API_URL/todos | jq .
echo ""

# Получение задачи по ID
echo "4. Получение задачи по ID..."
curl -s $API_URL/todos/$TASK_ID | jq .
echo ""

# Обновление задачи
echo "5. Обновление задачи..."
curl -s -X PUT $API_URL/todos/$TASK_ID \
  -H "Content-Type: application/json" \
  -d '{"title": "Обновленная задача", "completed": true}' | jq .
echo ""

# Удаление задачи
echo "6. Удаление задачи..."
curl -s -X DELETE $API_URL/todos/$TASK_ID | jq .
echo ""

# Проверка удаления
echo "7. Проверка удаления (должна вернуть 404)..."
curl -s $API_URL/todos/$TASK_ID | jq .
echo ""

echo "✅ Тестирование завершено!"

