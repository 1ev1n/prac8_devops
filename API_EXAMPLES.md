# Примеры использования API

## Базовый URL

- Локально: `http://localhost:3000`
- Kubernetes (Minikube): `http://NODE_IP:30080` или через `minikube service todo-api-service -n todo-app`

## Эндпоинты

### 1. Health Check

Проверка работоспособности приложения.

```bash
GET /health
```

**Пример запроса:**
```bash
curl http://localhost:3000/health
```

**Ответ:**
```json
{
  "status": "OK",
  "timestamp": "2024-01-15T10:30:00.000Z"
}
```

---

### 2. Получить все задачи

```bash
GET /todos
```

**Пример запроса:**
```bash
curl http://localhost:3000/todos
```

**Ответ:**
```json
[
  {
    "_id": "65a1b2c3d4e5f6g7h8i9j0k1",
    "title": "Изучить Kubernetes",
    "description": "Практическая работа №8.1",
    "completed": false,
    "createdAt": "2024-01-15T10:00:00.000Z"
  }
]
```

---

### 3. Создать новую задачу

```bash
POST /todos
Content-Type: application/json
```

**Пример запроса:**
```bash
curl -X POST http://localhost:3000/todos \
  -H "Content-Type: application/json" \
  -d '{
    "title": "Изучить Kubernetes",
    "description": "Практическая работа №8.1",
    "completed": false
  }'
```

**Тело запроса (JSON):**
```json
{
  "title": "Изучить Kubernetes",
  "description": "Практическая работа №8.1",
  "completed": false
}
```

**Ответ:**
```json
{
  "_id": "65a1b2c3d4e5f6g7h8i9j0k1",
  "title": "Изучить Kubernetes",
  "description": "Практическая работа №8.1",
  "completed": false,
  "createdAt": "2024-01-15T10:00:00.000Z"
}
```

---

### 4. Получить задачу по ID

```bash
GET /todos/:id
```

**Пример запроса:**
```bash
curl http://localhost:3000/todos/65a1b2c3d4e5f6g7h8i9j0k1
```

**Ответ:**
```json
{
  "_id": "65a1b2c3d4e5f6g7h8i9j0k1",
  "title": "Изучить Kubernetes",
  "description": "Практическая работа №8.1",
  "completed": false,
  "createdAt": "2024-01-15T10:00:00.000Z"
}
```

**Ошибка (404):**
```json
{
  "error": "Задача не найдена"
}
```

---

### 5. Обновить задачу

```bash
PUT /todos/:id
Content-Type: application/json
```

**Пример запроса:**
```bash
curl -X PUT http://localhost:3000/todos/65a1b2c3d4e5f6g7h8i9j0k1 \
  -H "Content-Type: application/json" \
  -d '{
    "title": "Изучить Kubernetes (обновлено)",
    "description": "Практическая работа №8.1 - завершено",
    "completed": true
  }'
```

**Тело запроса (JSON):**
```json
{
  "title": "Изучить Kubernetes (обновлено)",
  "description": "Практическая работа №8.1 - завершено",
  "completed": true
}
```

**Ответ:**
```json
{
  "_id": "65a1b2c3d4e5f6g7h8i9j0k1",
  "title": "Изучить Kubernetes (обновлено)",
  "description": "Практическая работа №8.1 - завершено",
  "completed": true,
  "createdAt": "2024-01-15T10:00:00.000Z"
}
```

---

### 6. Удалить задачу

```bash
DELETE /todos/:id
```

**Пример запроса:**
```bash
curl -X DELETE http://localhost:3000/todos/65a1b2c3d4e5f6g7h8i9j0k1
```

**Ответ:**
```json
{
  "message": "Задача успешно удалена",
  "todo": {
    "_id": "65a1b2c3d4e5f6g7h8i9j0k1",
    "title": "Изучить Kubernetes",
    "description": "Практическая работа №8.1",
    "completed": false,
    "createdAt": "2024-01-15T10:00:00.000Z"
  }
}
```

---

## Примеры использования с PowerShell (Windows)

### Получить все задачи
```powershell
Invoke-RestMethod -Uri "http://localhost:3000/todos" -Method Get
```

### Создать задачу
```powershell
$body = @{
    title = "Изучить Kubernetes"
    description = "Практическая работа №8.1"
    completed = $false
} | ConvertTo-Json

Invoke-RestMethod -Uri "http://localhost:3000/todos" -Method Post -Body $body -ContentType "application/json"
```

### Обновить задачу
```powershell
$body = @{
    title = "Изучить Kubernetes (обновлено)"
    completed = $true
} | ConvertTo-Json

Invoke-RestMethod -Uri "http://localhost:3000/todos/TODO_ID" -Method Put -Body $body -ContentType "application/json"
```

### Удалить задачу
```powershell
Invoke-RestMethod -Uri "http://localhost:3000/todos/TODO_ID" -Method Delete
```

## Коды ответов

- `200 OK` - Успешный запрос
- `201 Created` - Ресурс успешно создан
- `400 Bad Request` - Неверный формат запроса
- `404 Not Found` - Ресурс не найден
- `500 Internal Server Error` - Ошибка сервера

