# Практическая работа №8.1
## Развертывание REST API приложения в кластере Kubernetes

Этот проект представляет собой REST API для управления задачами (Todo), развернутое в Kubernetes с использованием MongoDB в качестве базы данных.

## Описание проекта

Приложение предоставляет REST API для управления задачами со следующими эндпоинтами:
- `GET /todos` - Получить все задачи
- `POST /todos` - Создать новую задачу
- `GET /todos/:id` - Получить одну задачу по id
- `PUT /todos/:id` - Обновить задачу по id
- `DELETE /todos/:id` - Удалить задачу по id

## Технологии

- **Node.js** + **Express** - Backend фреймворк
- **MongoDB** - База данных
- **Docker** - Контейнеризация
- **Kubernetes** - Оркестрация контейнеров
- **GitHub Actions** - CI/CD пайплайн

## Структура проекта

```
.
├── server.js                 # Основной файл приложения
├── package.json              # Зависимости Node.js
├── Dockerfile                # Образ Docker для приложения
├── .dockerignore            # Исключения для Docker
├── .gitignore               # Исключения для Git
├── k8s/                     # Kubernetes манифесты
│   ├── namespace.yaml
│   ├── mongodb-deployment.yaml
│   └── todo-api-deployment.yaml
├── .github/workflows/       # GitHub Actions
│   └── ci-cd.yml
└── README.md
```

## Предварительные требования

- Node.js 18+
- Docker
- Kubernetes (Minikube или другой кластер)
- kubectl
- Аккаунт на Docker Hub (для CI/CD)

## Локальная разработка

### Вариант 1: С использованием Docker Compose (рекомендуется)

```bash
# Запуск всего стека (MongoDB + API)
docker-compose up -d

# Просмотр логов
docker-compose logs -f

# Остановка
docker-compose down
```

### Вариант 2: Локальная разработка без Docker

#### 1. Установка зависимостей

```bash
npm install
```

#### 2. Настройка переменных окружения

Создайте файл `.env`:

```env
PORT=3000
MONGODB_URI=mongodb://localhost:27017/todos
```

#### 3. Запуск MongoDB локально

```bash
docker run -d -p 27017:27017 --name mongodb mongo:7.0
```

#### 4. Запуск приложения

```bash
npm start
# или для разработки с автоперезагрузкой
npm run dev
```

Приложение будет доступно по адресу: `http://localhost:3000`

## Развертывание в Kubernetes

### 1. Установка Minikube

```bash
# Windows (с Chocolatey)
choco install minikube

# Или скачайте с https://minikube.sigs.k8s.io/docs/start/
```

### 2. Запуск Minikube

```bash
minikube start
```

### 3. Сборка Docker образа

```bash
# Соберите образ локально
docker build -t todo-api:latest .

# Или используйте Docker Hub
docker build -t YOUR_DOCKERHUB_USERNAME/todo-api:latest .
docker push YOUR_DOCKERHUB_USERNAME/todo-api:latest
```

### 4. Обновление манифеста Kubernetes

Перед развертыванием обновите файл `k8s/todo-api-deployment.yaml`:
- Замените `YOUR_DOCKERHUB_USERNAME` на ваш username в Docker Hub

### 5. Развертывание в Kubernetes

**Автоматическое развертывание (рекомендуется):**

```bash
# Linux/Mac
chmod +x deploy.sh
./deploy.sh

# Windows
deploy.bat
```

**Ручное развертывание:**

```bash
# Создать namespace
kubectl apply -f k8s/namespace.yaml

# Развернуть MongoDB
kubectl apply -f k8s/mongodb-deployment.yaml -n todo-app

# Развернуть приложение
kubectl apply -f k8s/todo-api-deployment.yaml -n todo-app

# Проверить статус
kubectl get pods -n todo-app
kubectl get services -n todo-app
```

### 6. Доступ к приложению

```bash
# Получить URL через Minikube
minikube service todo-api-service -n todo-app

# Или получить NodePort напрямую
kubectl get service todo-api-service -n todo-app
```

Приложение будет доступно по адресу: `http://NODE_IP:30080`

## Настройка CI/CD с GitHub Actions

### 1. Создание секретов в GitHub

Перейдите в Settings → Secrets and variables → Actions и добавьте:

- `DOCKERHUB_USERNAME` - ваш username в Docker Hub
- `DOCKERHUB_TOKEN` - токен доступа Docker Hub
- `KUBECONFIG` - содержимое файла kubeconfig (закодированное в base64)

### 2. Получение kubeconfig

```bash
# Для Minikube
minikube kubectl config view --flatten | base64

# Для других кластеров
cat ~/.kube/config | base64
```

### 3. Автоматическое развертывание

После настройки секретов, каждый push в ветку `main` или `master` будет:
1. Собирать Docker образ
2. Отправлять его в Docker Hub
3. Развертывать приложение в Kubernetes

## Тестирование API

Подробные примеры использования API находятся в файле [API_EXAMPLES.md](API_EXAMPLES.md).

### Быстрый старт

**Создать задачу:**
```bash
curl -X POST http://localhost:3000/todos \
  -H "Content-Type: application/json" \
  -d '{"title": "Изучить Kubernetes", "description": "Практическая работа №8.1"}'
```

**Получить все задачи:**
```bash
curl http://localhost:3000/todos
```

**Получить задачу по ID:**
```bash
curl http://localhost:3000/todos/TODO_ID
```

**Обновить задачу:**
```bash
curl -X PUT http://localhost:3000/todos/TODO_ID \
  -H "Content-Type: application/json" \
  -d '{"title": "Изучить Kubernetes", "completed": true}'
```

**Удалить задачу:**
```bash
curl -X DELETE http://localhost:3000/todos/TODO_ID
```

**Health check:**
```bash
curl http://localhost:3000/health
```

### Автоматическое тестирование

Используйте скрипт для автоматического тестирования всех эндпоинтов:

```bash
# Linux/Mac
chmod +x test-api.sh
./test-api.sh http://localhost:3000

# Windows (PowerShell)
# Используйте примеры из API_EXAMPLES.md
```

## Полезные команды Kubernetes

```bash
# Просмотр подов
kubectl get pods -n todo-app

# Просмотр логов
kubectl logs -f deployment/todo-api-deployment -n todo-app
kubectl logs -f deployment/mongodb-deployment -n todo-app

# Описание ресурса
kubectl describe deployment todo-api-deployment -n todo-app

# Масштабирование
kubectl scale deployment todo-api-deployment --replicas=3 -n todo-app

# Удаление развертывания
kubectl delete -f k8s/todo-api-deployment.yaml -n todo-app
kubectl delete -f k8s/mongodb-deployment.yaml -n todo-app
kubectl delete namespace todo-app
```

## Решение проблем

### Приложение не может подключиться к MongoDB

Проверьте:
1. MongoDB развернут и работает: `kubectl get pods -n todo-app`
2. Service для MongoDB создан: `kubectl get svc -n todo-app`
3. В переменной окружения `MONGODB_URI` указан правильный адрес: `mongodb://mongodb-service:27017/todos`

### Поды не запускаются

```bash
# Проверить события
kubectl get events -n todo-app --sort-by='.lastTimestamp'

# Описание пода
kubectl describe pod POD_NAME -n todo-app
```

## Дополнительные ресурсы

- [Документация Kubernetes](https://kubernetes.io/docs/home/)
- [Документация Minikube](https://minikube.sigs.k8s.io/docs/start/)
- [Руководство по Dockerfile](https://docs.docker.com/engine/reference/builder/)
- [Руководство YAML для развертывания Kubernetes](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/)

## Автор

Практическая работа №8.1 - Развертывание REST API в Kubernetes

