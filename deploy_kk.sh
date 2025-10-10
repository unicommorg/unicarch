#!/bin/bash
# -*- coding: utf-8 -*-
# vim: set fileencoding=utf-8:

set -e

# Цвета для вывода
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Функции для вывода
print_info() { echo -e "${BLUE}ℹ️  $1${NC}"; }
print_success() { echo -e "${GREEN}✅ $1${NC}"; }
print_warning() { echo -e "${YELLOW}⚠️  $1${NC}"; }
print_error() { echo -e "${RED}❌ $1${NC}"; }

# Функция установки Docker
install_docker() {
    print_info "=== 🐳 Установка Docker и компонентов ==="
    
    # Проверяем, не установлен ли уже Docker
    if command -v docker &> /dev/null && docker compose version &> /dev/null; then
        print_success "Docker и Docker Compose уже установлены"
        docker --version
        docker compose version
        return 0
    fi
    
    print_info "Удаляем конфликтующие пакеты..."
    sudo apt remove -y containerd || true
    sudo apt autoremove -y

    print_info "Обновляем пакеты и устанавливаем зависимости..."
    sudo apt update -y
    sudo apt install -y ca-certificates curl gnupg lsb-release software-properties-common

    print_info "Добавляем Docker GPG ключ..."
    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
        sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    sudo chmod a+r /etc/apt/keyrings/docker.gpg

    print_info "Добавляем Docker репозиторий..."
    echo \
        "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
        https://download.docker.com/linux/ubuntu \
        $(. /etc/os-release; echo "$VERSION_CODENAME") stable" | \
        sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

    sudo apt update -y
    
    print_info "Устанавливаем Docker пакеты..."
    sudo apt install -y -f docker-ce docker-ce-cli containerd.io docker-compose-plugin docker-compose

    print_success "Docker и компоненты установлены:"
    echo "   - docker-ce, docker-ce-cli, containerd.io"
    echo "   - docker-compose-plugin, docker-compose"
    echo "   - ca-certificates, curl, gnupg, lsb-release, software-properties-common"
    
    # Добавляем текущего пользователя в группу docker
    print_info "Добавляем текущего пользователя в группу docker..."
    sudo usermod -aG docker $USER
    
    print_success "Установка Docker завершена. Перезагрузите систему или выполните 'newgrp docker'"
    return 0
}

# Функция проверки Docker
check_docker() {
    print_info "=== 1. 🔍 Проверка Docker ==="
    
    if command -v docker &> /dev/null && docker compose version &> /dev/null; then
        print_success "Docker и Docker Compose установлены"
        docker --version
        docker compose version
        return 0
    fi
    
    print_error "Docker не установлен или установлен не полностью"
    print_info "Хотите установить Docker автоматически? (y/N)"
    read -p "Ваш выбор: " choice
    if [[ $choice =~ ^[Yy]$ ]]; then
        install_docker
        return $?
    else
        return 1
    fi
}

# Функция создания сети
create_network() {
    print_info "=== 2. 🌐 Создание сети ua-keycloak ==="
    
    docker network create ua-keycloak 2>/dev/null || print_warning "Сеть ua-keycloak уже существует"
    print_success "Сеть ua-keycloak готова"
    return 0
}

# Функция создания .env файла
setup_env_file() {
    print_info "=== 3. 🔧 Настройка .env файла ==="
    
    if [ ! -f "initconfig.txt" ]; then
        print_error "initconfig.txt не найден"
        return 1
    fi
    
    source initconfig.txt
    
    if [ -z "$KEYCLOAK_URL" ]; then
        print_error "KEYCLOAK_URL не установлен в initconfig.txt"
        return 1
    fi
    
    # Создаем .env файл с новой структурой
    print_info "Создаем kk/.env файл..."
    cat > kk/.env << EOF
# ========== VERSIONS ==========
KEYCLOAK_VERSION=26.1.2
POSTGRES_VERSION=15

# ========== KEYCLOAK SETTINGS ==========
KC_HOSTNAME=${KEYCLOAK_URL}
PROXY_ADDRESS_FORWARDING=true
KC_HTTP_ENABLED=true
KC_HTTP_RELATIVE_PATH=/

# ========== DATABASE SETTINGS ==========
KC_DB_DATABASE=keycloak
KC_DB_USERNAME=keycloak
KC_DB_PASSWORD=password
KC_DB_SCHEMA=public

# ========== ADMIN ACCESS ==========
KEYCLOAK_ADMIN=admin
KEYCLOAK_ADMIN_PASSWORD=admin
EOF
    
    print_success ".env файл создан"
    
    # Показываем содержимое для проверки
    print_info "Содержимое kk/.env:"
    cat kk/.env
    return 0
}

# Функция настройки docker-compose.yml
setup_docker_compose() {
    print_info "=== 4. 🐳 Настройка docker-compose.yml ==="
    
    if [ ! -f "kk/docker-compose.yml" ]; then
        print_error "kk/docker-compose.yml не найден"
        return 1
    fi
    
    # Проверяем, что docker-compose.yml имеет правильную структуру
    if ! grep -q "KEYCLOAK_VERSION" kk/docker-compose.yml; then
        print_warning "docker-compose.yml не использует переменные из .env"
        print_info "Рекомендуется обновить docker-compose.yml до новой версии"
    fi
    
    print_success "docker-compose.yml проверен"
    return 0
}

# Функция настройки realm
setup_realm_config() {
    print_info "=== 5. ⚙️ Настройка realm конфигурации ==="
    
    if [ ! -f "initconfig.txt" ]; then
        print_error "initconfig.txt не найден"
        return 1
    fi
    
    source initconfig.txt
    
    if [ ! -f "kk/unicarch_realm.json" ]; then
        print_error "kk/unicarch_realm.json не найден"
        return 1
    fi
    
    REQUIRED_VARS=("KEYCLOAK_URL" "KEYCLOAK_REALM" "KEYCLOAK_CLIENT" "VITE_HOST_URL")
    for var in "${REQUIRED_VARS[@]}"; do
        if [ -z "${!var}" ]; then
            print_error "Переменная $var не установлена"
            return 1
        fi
    done
    
    print_info "Настраиваем realm: $KEYCLOAK_REALM"
    print_info "Настраиваем client: $KEYCLOAK_CLIENT"
    print_info "Настраиваем URL: $KEYCLOAK_URL"
    print_info "Настраиваем API URL: $VITE_HOST_URL"
    
    # Создаем временный файл для модификаций
    cp kk/unicarch_realm.json kk/unicarch_realm_modified.json
    
    # Извлекаем домены из URL
    KEYCLOAK_DOMAIN=$(echo "$KEYCLOAK_URL" | sed 's|https://||')
    # Для unicarch_dns берем домен без /api
    API_DOMAIN=$(echo "$VITE_HOST_URL" | sed 's|https://||' | sed 's|/api||')
    
    print_info "Заменяем значения в realm JSON..."
    
    # 1. Заменяем имя realm
    sed -i "s/\"realm\": \".*\"/\"realm\": \"$KEYCLOAK_REALM\"/g" kk/unicarch_realm_modified.json
    
    # 2. Заменяем displayName
    sed -i "s/\"displayName\": \".*\"/\"displayName\": \"$KEYCLOAK_REALM\"/g" kk/unicarch_realm_modified.json
    
    # 3. Заменяем clientId во всех клиентах
    sed -i "s/\"clientId\": \"ua-frontend-client\"/\"clientId\": \"$KEYCLOAK_CLIENT\"/g" kk/unicarch_realm_modified.json
    
    # 4. Заменяем URLs в клиентах (redirectUris, webOrigins, adminUrl, baseUrl)
    sed -i "s|https://uabrkktest.unic.chat|$KEYCLOAK_URL|g" kk/unicarch_realm_modified.json
    sed -i "s|uabrkktest.unic.chat|$KEYCLOAK_DOMAIN|g" kk/unicarch_realm_modified.json
    
    # 5. Заменяем API URLs (uabrtest.unic.chat)
    sed -i "s|https://uabrtest.unic.chat|$VITE_HOST_URL|g" kk/unicarch_realm_modified.json
    sed -i "s|uabrtest.unic.chat|$API_DOMAIN|g" kk/unicarch_realm_modified.json
    
    # 6. Заменяем unicarch_dns на API домен БЕЗ /api (исправлено!)
    sed -i "s|https://unicarch_dns|https://$API_DOMAIN|g" kk/unicarch_realm_modified.json
    sed -i "s|unicarch_dns|$API_DOMAIN|g" kk/unicarch_realm_modified.json
    
    # 7. Заменяем URLs в identity providers если есть
    sed -i "s|https://keycloak_dns|$KEYCLOAK_URL|g" kk/unicarch_realm_modified.json
    sed -i "s|keycloak_dns|$KEYCLOAK_DOMAIN|g" kk/unicarch_realm_modified.json
    
    # 8. Заменяем issuer в клиентах если есть
    sed -i "s|\"issuer\": \".*\"|\"issuer\": \"$KEYCLOAK_URL/realms/$KEYCLOAK_REALM\"|g" kk/unicarch_realm_modified.json
    
    # 9. Заменяем URLs в realm settings если есть
    sed -i "s|\"frontendUrl\": \".*\"|\"frontendUrl\": \"$KEYCLOAK_URL\"|g" kk/unicarch_realm_modified.json
    
    print_success "Realm конфигурация настроена"
    
    # Показываем какие замены были сделаны
    print_info "Выполненные замены:"
    print_info "  - realm: → $KEYCLOAK_REALM"
    print_info "  - clientId: ua-frontend-client → $KEYCLOAK_CLIENT"
    print_info "  - Keycloak URLs: uabrkktest.unic.chat → $KEYCLOAK_DOMAIN"
    print_info "  - API URLs: uabrtest.unic.chat → $API_DOMAIN"
    print_info "  - unicarch_dns → $API_DOMAIN (без /api)"
    print_info "  - Все https://uabrkktest.unic.chat → $KEYCLOAK_URL"
    print_info "  - Все https://uabrtest.unic.chat → $VITE_HOST_URL"
    print_info "  - Все https://unicarch_dns → https://$API_DOMAIN"
    
    print_info "Исходный файл: kk/unicarch_realm.json"
    print_info "Модифицированный файл: kk/unicarch_realm_modified.json"
    
    # Показываем пример измененных redirectUris и webOrigins
    print_info "Пример изменений в клиенте:"
    grep -A 3 -B 3 "redirectUris" kk/unicarch_realm_modified.json | head -10
    
    return 0
}

# Функция запуска Keycloak
start_keycloak() {
    print_info "=== 6. 🚀 Запуск Keycloak ==="
    
    # Проверяем существование .env файла
    if [ ! -f "kk/.env" ]; then
        print_error "kk/.env не найден. Сначала выполните настройку .env файла"
        return 1
    fi
    
    cd kk && docker compose up -d && cd ..
    
    # Ждем запуска Keycloak
    print_info "⏳ Ожидание запуска Keycloak..."
    max_attempts=30
    attempt=1
    while [ $attempt -le $max_attempts ]; do
        if curl -s http://localhost:8080/health/ready > /dev/null 2>&1; then
            print_success "Keycloak запущен и готов"
            return 0
        fi
        echo "   Попытка $attempt из $max_attempts..."
        sleep 5
        ((attempt++))
    done
    
    print_error "Keycloak не запустился за отведенное время"
    return 1
}

# Функция импорта realm
import_realm() {
    print_info "=== 7. 📥 Импорт realm ==="
    
    # Настройки для импорта
    KEYCLOAK_HOST="localhost"
    KEYCLOAK_PORT="8080"
    KEYCLOAK_ADMIN_USER="admin"
    KEYCLOAK_ADMIN_PASSWORD="admin"
    REALM_FILE="kk/unicarch_realm_modified.json"
    
    KEYCLOAK_URL="http://${KEYCLOAK_HOST}:${KEYCLOAK_PORT}"

    print_info "=========================================="
    print_info "Keycloak Realm Import Script"
    print_info "Target: ${KEYCLOAK_URL}"
    print_info "Realm file: ${REALM_FILE}"
    print_info "=========================================="

    # Проверяем существование файла realm
    if [ ! -f "$REALM_FILE" ]; then
        print_error "Файл ${REALM_FILE} не найден!"
        return 1
    fi

    print_info "[1/3] Получение токена администратора..."
    TOKEN_RESPONSE=$(curl -s -X POST \
      "${KEYCLOAK_URL}/realms/master/protocol/openid-connect/token" \
      -H "Content-Type: application/x-www-form-urlencoded" \
      -d "username=${KEYCLOAK_ADMIN_USER}&password=${KEYCLOAK_ADMIN_PASSWORD}&grant_type=password&client_id=admin-cli")
    
    # Используем jq если установлен, иначе grep
    if command -v jq &> /dev/null; then
        TOKEN=$(echo "$TOKEN_RESPONSE" | jq -r '.access_token')
    else
        TOKEN=$(echo "$TOKEN_RESPONSE" | grep -o '"access_token":"[^"]*' | cut -d'"' -f4)
    fi

    if [ -z "$TOKEN" ] || [ "$TOKEN" = "null" ]; then
        print_error "Не удалось получить токен администратора"
        print_info "Проверьте:"
        print_info "  - Keycloak запущен на ${KEYCLOAK_URL}"
        print_info "  - Креды администратора корректны"
        print_info "  - Сетевое подключение"
        echo "Ответ сервера: $TOKEN_RESPONSE"
        return 1
    fi

    print_success "[2/3] Токен получен успешно!"

    print_info "[3/3] Импорт realm..."
    RESPONSE=$(curl -s -w "\n%{http_code}" -X POST \
      "${KEYCLOAK_URL}/admin/realms" \
      -H "Authorization: Bearer $TOKEN" \
      -H "Content-Type: application/json" \
      -d @"${REALM_FILE}")

    HTTP_CODE=$(echo "$RESPONSE" | tail -n1)
    RESPONSE_BODY=$(echo "$RESPONSE" | head -n -1)

    if [ "$HTTP_CODE" -eq 201 ]; then
        print_success "✅ SUCCESS: Realm импортирован успешно!"
        print_info "HTTP Status: $HTTP_CODE (Created)"
    elif [ "$HTTP_CODE" -eq 409 ]; then
        print_warning "⚠️  WARNING: Realm уже существует (HTTP 409 Conflict)"
        print_info "Можно удалить существующий realm или использовать другой"
    else
        print_error "❌ ERROR: Ошибка импорта realm"
        print_info "HTTP Status: $HTTP_CODE"
        print_info "Response: $RESPONSE_BODY"
        return 1
    fi

    print_info "=========================================="
    return 0
}

# Функция проверки realm
check_realm() {
    print_info "=== 🔍 Проверка realm ==="
    
    KEYCLOAK_URL="http://localhost:8080"
    source initconfig.txt
    REALM_NAME="${KEYCLOAK_REALM}"
    
    print_info "[1/2] Получение токена администратора..."
    TOKEN_RESPONSE=$(curl -s -X POST \
      "${KEYCLOAK_URL}/realms/master/protocol/openid-connect/token" \
      -H "Content-Type: application/x-www-form-urlencoded" \
      -d "username=admin&password=admin&grant_type=password&client_id=admin-cli")
    
    if command -v jq &> /dev/null; then
        TOKEN=$(echo "$TOKEN_RESPONSE" | jq -r '.access_token')
    else
        TOKEN=$(echo "$TOKEN_RESPONSE" | grep -o '"access_token":"[^"]*' | cut -d'"' -f4)
    fi

    if [ -z "$TOKEN" ] || [ "$TOKEN" = "null" ]; then
        print_error "Не удалось получить токен"
        return 1
    fi

    print_success "[2/2] Проверка realm '${REALM_NAME}'..."
    RESPONSE=$(curl -s -w "\n%{http_code}" -X GET \
      "${KEYCLOAK_URL}/admin/realms/${REALM_NAME}" \
      -H "Authorization: Bearer $TOKEN")

    HTTP_CODE=$(echo "$RESPONSE" | tail -n1)
    RESPONSE_BODY=$(echo "$RESPONSE" | head -n -1)

    if [ "$HTTP_CODE" -eq 200 ]; then
        print_success "✅ Realm '${REALM_NAME}' существует и доступен"
        
        # Парсим базовую информацию о realm
        if command -v jq &> /dev/null; then
            echo "Информация о realm:"
            echo "$RESPONSE_BODY" | jq '{realm: .realm, displayName: .displayName, enabled: .enabled}'
        else
            echo "Realm: $REALM_NAME (HTTP 200 OK)"
        fi
    else
        print_error "❌ Realm '${REALM_NAME}' не существует (код: $HTTP_CODE)"
        return 1
    fi
    
    return 0
}

# Функция полной настройки
full_setup() {
    print_info "=== 🚀 Запуск полной настройки Keycloak ==="
    
    check_docker && \
    create_network && \
    setup_env_file && \
    setup_docker_compose && \
    setup_realm_config && \
    start_keycloak && \
    import_realm && \
    print_success "=== ✅ Полная настройка Keycloak завершена! ==="
}

# Функция остановки Keycloak
stop_keycloak() {
    print_info "=== 🛑 Остановка Keycloak ==="
    cd kk && docker compose down && cd ..
    print_success "Keycloak остановлен"
}

# Функция показа статуса
show_status() {
    print_info "=== 📊 Статус Keycloak ==="
    
    echo "Сервисы:"
    cd kk && docker compose ps && cd ..
    
    echo ""
    echo "Проверка здоровья:"
    if curl -s http://localhost:8080/health/ready > /dev/null 2>&1; then
        print_success "Keycloak готов"
    else
        print_error "Keycloak не отвечает"
    fi
    
    # Показываем настройки из .env
    if [ -f "kk/.env" ]; then
        echo ""
        print_info "Текущие настройки из .env:"
        grep -E '^(KEYCLOAK_VERSION|KC_HOSTNAME|KEYCLOAK_ADMIN)' kk/.env
    fi
}

# Функция показа .env файла
show_env() {
    print_info "=== 📄 Содержимое .env файла ==="
    if [ -f "kk/.env" ]; then
        cat kk/.env
    else
        print_error "kk/.env не найден"
    fi
}


# Функция полной установки с Docker
full_install_with_docker() {
    print_info "=== 🌟 ПОЛНАЯ УСТАНОВКА С НУЛЯ ==="
    print_info "Это действие выполнит:"
    print_info "1. 🐳 Установку Docker и Docker Compose"
    print_info "2. 🌐 Создание сети"
    print_info "3. 📄 Настройку .env файла"
    print_info "4. 🐳 Проверку docker-compose.yml"
    print_info "5. ⚙️ Настройку realm конфигурации"
    print_info "6. 🚀 Запуск Keycloak"
    print_info "7. 📥 Импорт realm"
    echo ""
    print_warning "⚠️ Внимание! Это может занять несколько минут."
    read -p "🔄 Продолжить полную установку? (y/N): " confirm

    if [[ ! $confirm =~ ^[Yy]$ ]]; then
        print_info "Отменено пользователем"
        return 0
    fi

    print_info "🚀 Начинаем полную установку..."
    echo ""

    # Шаг 1: Установка Docker
    print_info "📦 ШАГ 1/7: Установка Docker"
    if ! install_docker; then
        print_error "❌ Ошибка на этапе установки Docker"
        return 1
    fi
    echo ""

    # Шаг 2: Создание сети
    print_info "🌐 ШАГ 2/7: Создание сети"
    if ! create_network; then
        print_error "❌ Ошибка на этапе создания сети"
        return 1
    fi
    echo ""

    # Шаг 3: Настройка .env файла
    print_info "📄 ШАГ 3/7: Настройка .env файла"
    if ! setup_env_file; then
        print_error "❌ Ошибка на этапе создания .env файла"
        return 1
    fi
    echo ""

    # Шаг 4: Проверка docker-compose.yml
    print_info "🐳 ШАГ 4/7: Проверка docker-compose.yml"
    if ! setup_docker_compose; then
        print_error "❌ Ошибка на этапе проверки docker-compose.yml"
        return 1
    fi
    echo ""

    # Шаг 5: Настройка realm конфигурации
    print_info "⚙️ ШАГ 5/7: Настройка realm конфигурации"
    if ! setup_realm_config; then
        print_error "❌ Ошибка на этапе настройки realm конфигурации"
        return 1
    fi
    echo ""

    # Шаг 6: Запуск Keycloak
    print_info "🚀 ШАГ 6/7: Запуск Keycloak"
    if ! start_keycloak; then
        print_error "❌ Ошибка на этапе запуска Keycloak"
        return 1
    fi
    echo ""

    # Шаг 7: Импорт realm
    print_info "📥 ШАГ 7/7: Импорт realm"
    if ! import_realm; then
        print_error "❌ Ошибка на этапе импорта realm"
        return 1
    fi
    echo ""

    print_success "🎉 ПОЛНАЯ УСТАНОВКА ЗАВЕРШЕНА УСПЕШНО!"
    print_info "🔗 Keycloak доступен по адресу: http://localhost:8080"
    print_info "👤 Администратор: admin / admin"

    # Показываем итоговую информацию
    if [ -f "initconfig.txt" ]; then
        source initconfig.txt
        if [ ! -z "$KEYCLOAK_URL" ]; then
            print_info "🌐 Внешний URL: $KEYCLOAK_URL"
        fi
        if [ ! -z "$KEYCLOAK_REALM" ]; then
            print_info "🏛️ Realm: $KEYCLOAK_REALM"
        fi
    fi

    echo ""
    print_info "✅ Система готова к использованию!"
    return 0
}

# Главное меню
show_menu() {
    echo ""
    print_info "=== 🔐 Менеджер развертывания Keycloak ==="
    echo ""
    echo "1. 🐳 Установить Docker"
    echo "2. 🔍 Проверить Docker"
    echo "3. 🌐 Создать сеть"
    echo "4. 📄 Создать .env файл"
    echo "5. 🐳 Проверить docker-compose.yml"
    echo "6. ⚙️ Настроить realm конфигурацию"
    echo "7. 🚀 Запустить Keycloak"
    echo "8. 📥 Импортировать realm"
    echo "9. 🚀 Полная настройка (все шаги)"
    echo "10. 🛑 Остановить Keycloak"
    echo "11. 📊 Показать статус"
    echo "12. 🔍 Проверить realm"
    echo "13. 👀 Показать .env файл"
    echo ""
    echo "100. 🌟 Полная установка с нуля (Docker + все настройки)"
    echo ""
    echo "0. ❌ Выход"
    echo ""
}

# Основной цикл программы
main() {
    while true; do
        show_menu
        read -p "Выберите действие [0-13, 100]: " choice
        
        case $choice in
            1) install_docker ;;
            2) check_docker ;;
            3) create_network ;;
            4) setup_env_file ;;
            5) setup_docker_compose ;;
            6) setup_realm_config ;;
            7) start_keycloak ;;
            8) import_realm ;;
            9) full_setup ;;
            10) stop_keycloak ;;
            11) show_status ;;
            12) check_realm ;;
            13) show_env ;;
            100) full_install_with_docker ;;
            0) 
                print_info "Выход..."
                exit 0
                ;;
            *)
                print_error "Неверный выбор"
                ;;
        esac
        
        echo ""
        read -p "Нажмите Enter чтобы продолжить..."
    done
}

# Запуск основной программы
main
