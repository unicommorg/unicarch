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

# Функция проверки статуса Docker
check_docker_status() {
    print_info "Проверка статуса Docker..."
    
    # Проверяем наличие Docker
    if command -v docker &> /dev/null; then
        print_success "Docker установлен:"
        docker --version
    else
        print_warning "Docker не установлен"
    fi

    # Проверяем наличие Docker Compose
    if command -v docker-compose &> /dev/null; then
        print_success "Docker Compose установлен:"
        docker-compose --version
    else
        print_warning "Docker Compose не установлен"
    fi

    # Проверяем наличие Docker Compose Plugin
    if command -v docker &> /dev/null && docker compose version &> /dev/null; then
        print_success "Docker Compose Plugin установлен:"
        docker compose version
    fi
}

# Функция проверки доступности Docker
ensure_docker() {
    if ! command -v docker &> /dev/null || ! command -v docker-compose &> /dev/null; then
        print_error "Docker не установлен или недоступен"
        echo "Пожалуйста, установите Docker используя пункт 1 в меню"
        return 1
    fi
    return 0
}

# Функция установки Docker
install_docker() {
    print_info "=== 🐳 Установка Docker ==="
    
    echo ""
    print_warning "ВНИМАНИЕ: Это установит Docker из официальных репозиториев"
    echo "Будут выполнены следующие действия:"
    echo "  • Удалены конфликтующие пакеты"
    echo "  • Установлены зависимости"
    echo "  • Добавлен официальный репозиторий Docker"
    echo "  • Установлены docker-ce, docker-compose-plugin, docker-compose"
    echo "  • Пользователь добавлен в группу docker"
    echo ""
    
    read -p "Вы уверены что хотите продолжить установку Docker? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_info "Установка Docker отменена пользователем"
        return 1
    fi

    print_info "1. Удаление конфликтующих пакетов..."
    sudo apt remove -y containerd || true
    sudo apt autoremove -y

    print_info "2. Обновление пакетов и установка зависимостей..."
    sudo apt update -y
    sudo apt install -y ca-certificates curl gnupg lsb-release software-properties-common

    print_info "3. Добавление GPG ключа Docker..."
    sudo mkdir -p /etc/apt/keyrings
    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
        sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    sudo chmod a+r /etc/apt/keyrings/docker.gpg

    print_info "4. Добавление репозитория Docker..."
    echo \
        "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
        https://download.docker.com/linux/ubuntu \
        $(. /etc/os-release; echo "$VERSION_CODENAME") stable" | \
        sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

    sudo apt update -y

    print_info "5. Установка Docker с разрешением зависимостей..."
    sudo apt install -y -f docker-ce docker-ce-cli containerd.io docker-compose-plugin docker-compose

    print_info "6. Настройка прав пользователя..."
    sudo usermod -aG docker $USER

    print_success "Docker и связанные компоненты установлены:"
    echo "   - docker-ce, docker-ce-cli, containerd.io"
    echo "   - docker-compose-plugin, docker-compose"
    echo "   - ca-certificates, curl, gnupg, lsb-release, software-properties-common"

    print_warning "Для применения изменений прав необходимо перезапустить терминал или выйти/войти в систему."
    
    echo ""
    read -p "Хотите перезапустить терминал сейчас? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        print_info "Перезапуск терминала..."
        exec bash
    else
        print_info "Вы можете продолжить работу, но для полного применения прав потребуется перезапуск терминала."
        return 0
    fi
}

# Функция входа в Yandex Container Registry
docker_login() {
    if ! ensure_docker; then
        return 1
    fi

    print_info "=== 🔐 Вход в Yandex Container Registry ==="
    
    # Данные для аутентификации
    local username="oauth"
    local password="y0_AgAAAAB3muX6AATuwQAAAAEawLLRAAB9TQHeGyxGPZXkjVDHF1ZNJcV8UQ"
    local registry="cr.yandex"

    print_info "Выполняется вход в реестр: $registry"
    
    # Выполняем docker login
    if echo "$password" | docker login --username "$username" --password-stdin "$registry"; then
        print_success "Успешный вход в Yandex Container Registry"
        return 0
    else
        print_error "Ошибка входа в Yandex Container Registry"
        echo "Проверьте правильность токена и доступ к интернету"
        return 1
    fi
}

# Функция для проверки наличия файлов
check_required_files() {
    local missing_files=()

    if [ ! -f "ua/docker-compose.vault.yml" ]; then
        missing_files+=("ua/docker-compose.vault.yml")
    fi

    if [ ! -f "ua/docker-compose.yml" ]; then
        missing_files+=("ua/docker-compose.yml")
    fi

    if [ ${#missing_files[@]} -ne 0 ]; then
        print_error "Отсутствуют необходимые файлы:"
        for file in "${missing_files[@]}"; do
            echo "  - $file"
        done
        echo "Убедитесь, что файлы находятся в папке ua/"
        return 1
    fi

    return 0
}

# Функция создания сети
create_network() {
    if ! ensure_docker; then
        return 1
    fi
    
    print_info "Создание сети ua-dev..."
    docker network create ua-dev 2>/dev/null || print_warning "Сеть ua-dev уже существует"
    print_success "Сеть ua-dev готова"
}

# Функция инициализации из initconfig.txt
init_from_config() {
    print_info "=== 🚀 Инициализация из initconfig.txt ==="

    # Проверяем наличие initconfig.txt
    if [ ! -f initconfig.txt ]; then
        print_error "initconfig.txt не найден"
        echo "Создайте файл initconfig.txt с настройками"
        return 1
    fi

    print_info "1. 📝 Создаем ua/.env файл из initconfig.txt..."
    cp initconfig.txt ua/.env

    # Добавляем пустой VAULT_TOKEN если его нет
    if ! grep -q "VAULT_TOKEN=" ua/.env; then
        echo "VAULT_TOKEN=" >> ua/.env
    fi

    print_success "ua/.env файл создан"
    return 0
}

# Функция настройки Vault
setup_vault() {
    if ! ensure_docker; then
        return 1
    fi

    print_info "=== 🚀 Настройка Vault ==="

    # Проверяем наличие ua/.env файла
    if [ ! -f ua/.env ]; then
        print_error "ua/.env файл не найден"
        echo "Сначала выполните инициализацию из initconfig.txt"
        return 1
    fi

    # Загружаем переменные из ua/.env
    source ua/.env

    # ========== ПРОВЕРКА ОБЯЗАТЕЛЬНЫХ ПЕРЕМЕННЫХ ==========
    REQUIRED_VARS=(
        "MONGO_INITDB_ROOT_USERNAME"
        "MONGO_INITDB_ROOT_PASSWORD"
        "MONGO_INITDB_DATABASE"
        "POSTGRES_DB"
        "POSTGRES_DB_USER"
        "POSTGRES_DB_PASSWORD"
        "MINIO_ROOT_USER"
        "MINIO_ROOT_PASSWORD"
        "MINIO_ENDPOINT"
        "REDIS_URL"
        "KEYCLOAK_URL"
        "KEYCLOAK_REALM"
        "KEYCLOAK_CLIENT"
        "KEYCLOAK_AUDIENCE"
        "VITE_ALLOWED_HOSTS"
        "VITE_KEYCLOAK_URL"
        "VITE_KEYCLOAK_REALM"
        "VITE_KEYCLOAK_CLIENT"
        "VITE_HOST_URL"
    )

    print_info "🔍 Проверка переменных окружения..."
    for var in "${REQUIRED_VARS[@]}"; do
        if [ -z "${!var}" ]; then
            print_error "Переменная $var не установлена в ua/.env файле"
            return 1
        fi
    done
    print_success "Все обязательные переменные установлены"

    # ========== ФОРМИРОВАНИЕ СТРОК ПОДКЛЮЧЕНИЯ ==========
    # ИСПРАВЛЕНО: используем правильные имена хостов из docker-compose
    POSTGRES_CONNECTION="Host=ua.postgres;Port=5432;Database=${POSTGRES_DB};Username=${POSTGRES_DB_USER};Password=${POSTGRES_DB_PASSWORD}"
    MONGODB_CONNECTION="mongodb://${MONGO_INITDB_ROOT_USERNAME}:${MONGO_INITDB_ROOT_PASSWORD}@ua.mongodb:27017/${MONGO_INITDB_DATABASE}?authSource=admin"

    print_info "PostgreSQL подключение: $POSTGRES_CONNECTION"
    print_info "MongoDB подключение: $MONGODB_CONNECTION"
    print_info "Redis URL: $REDIS_URL"
    print_info "MinIO endpoint: $MINIO_ENDPOINT"

    print_info "1. 🔐 Запуск Vault..."
    docker compose -f ua/docker-compose.vault.yml up -d

    # Ждем запуска Vault
    print_info "   ⏳ Ожидание запуска Vault..."
    max_attempts=30
    attempt=1
    while [ $attempt -le $max_attempts ]; do
        if curl -s http://localhost:8200/health > /dev/null 2>&1; then
            print_success "Vault запущен"
            break
        fi
        echo "   ⏱️  Попытка $attempt из $max_attempts..."
        sleep 5
        ((attempt++))
    done

    if [ $attempt -gt $max_attempts ]; then
        print_error "Vault не запустился за отведенное время"
        return 1
    fi

    print_info "2. 🎫 Получение токена Vault..."
    VAULT_TOKEN=$(curl -s -X GET "http://localhost:8200/api/vault/token/new")
    VAULT_TOKEN=$(echo "$VAULT_TOKEN" | tr -d '\r\n' | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')

    if [ -n "$VAULT_TOKEN" ]; then
        print_success "Токен получен: $VAULT_TOKEN"

        # Обновляем ua/.env файл
        if grep -q "VAULT_TOKEN=" ua/.env; then
            sed -i "s/VAULT_TOKEN=.*/VAULT_TOKEN=$VAULT_TOKEN/" ua/.env
        else
            echo "VAULT_TOKEN=$VAULT_TOKEN" >> ua/.env
        fi
        print_success "Токен записан в ua/.env файл"
    else
        print_error "Не удалось получить токен"
        return 1
    fi

    print_info "3. ⚙️ Настройка конфигурации Vault..."

    # Функция для установки значений в Vault
    set_vault_value() {
        local key=$1
        local value=$2

        # URL-encode токен (заменяем : на %3A)
        local encoded_token=$(echo "$VAULT_TOKEN" | sed 's/:/%3A/g')

        echo "   📝 Устанавливаю $key..."

        # Отправляем запрос в правильном формате
        response=$(curl -s -w "\n%{http_code}" -X POST \
            "http://localhost:8200/api/vault/$encoded_token/set/$key" \
            -H "accept: text/plain" \
            -H "Content-Type: application/json" \
            -d "\"$value\"")

        http_code=$(echo "$response" | tail -n1)
        response_body=$(echo "$response" | head -n -1)

        if [ "$http_code" -eq 200 ]; then
            echo "   ✅ $key установлен успешно"
            return 0
        else
            echo "   ❌ Ошибка установки $key (код: $http_code)"
            echo "   🔍 Тело ответа: $response_body"
            return 1
        fi
    }

    print_info "   📦 Начинаю настройку параметров Vault..."

    # Устанавливаем все значения через переменные
    set_vault_value "postgre" "$POSTGRES_CONNECTION"
    set_vault_value "KeyCloakURL" "$KEYCLOAK_URL"
    set_vault_value "KeyCloakAudience" "$KEYCLOAK_AUDIENCE"
    set_vault_value "redis" "$REDIS_URL"
    set_vault_value "KeyCloakRealm" "$KEYCLOAK_REALM"
    set_vault_value "KeyCloakClient" "$KEYCLOAK_CLIENT"
    set_vault_value "minio_name" "$MINIO_ROOT_USER"
    set_vault_value "minio_pass" "$MINIO_ROOT_PASSWORD"
    set_vault_value "minio_endpoint" "$MINIO_ENDPOINT"
    set_vault_value "mongodb" "$MONGODB_CONNECTION"

    print_success "=== Настройка Vault завершена! ==="
    print_info "Токен сохранен в ua/.env и настройки записаны в Vault"
    return 0
}

# Функция загрузки SQL файлов в PostgreSQL
load_sql_files() {
    if ! ensure_docker; then
        return 1
    fi

    print_info "=== 🗃️  Загрузка SQL файлов в PostgreSQL ==="

    # Проверяем наличие SQL файлов
    if [ ! -f "ua/structure.sql" ]; then
        print_error "Файл structure.sql не найден"
        return 1
    fi

    if [ ! -f "ua/specific_information.sql" ]; then
        print_error "Файл specific_information.sql не найден"
        return 1
    fi

    # Проверяем наличие ua/.env файла
    if [ ! -f ua/.env ]; then
        print_error "ua/.env файл не найден"
        echo "Сначала выполните инициализацию из initconfig.txt"
        return 1
    fi

    # Загружаем переменные из ua/.env
    source ua/.env

    # Проверяем обязательные переменные
    if [ -z "$POSTGRES_DB" ] || [ -z "$POSTGRES_DB_USER" ] || [ -z "$POSTGRES_DB_PASSWORD" ]; then
        print_error "Не установлены переменные PostgreSQL в ua/.env файле"
        return 1
    fi

    # Проверяем, запущен ли PostgreSQL контейнер
    if ! docker ps --format "table {{.Names}}" | grep -q "ua.postgres"; then
        print_warning "PostgreSQL контейнер не запущен. Запускаем сервисы..."
        start_services
    fi

    # Ждем запуска PostgreSQL с попытками подключения
    print_info "⏳ Ожидание запуска PostgreSQL и проверка подключения..."
    max_attempts=30
    attempt=1
    while [ $attempt -le $max_attempts ]; do
        # Пробуем подключиться к PostgreSQL
        if docker exec ua.postgres psql -U $POSTGRES_DB_USER -d $POSTGRES_DB -c "SELECT 1;" >/dev/null 2>&1; then
            print_success "PostgreSQL запущен и готов к работе"
            break
        fi
        echo "   ⏱️  Попытка подключения $attempt из $max_attempts..."
        sleep 5
        ((attempt++))
    done

    if [ $attempt -gt $max_attempts ]; then
        print_error "PostgreSQL не запустился за отведенное время или недоступен"
        print_info "Проверьте логи PostgreSQL: docker compose logs ua.postgres"
        return 1
    fi

    # Загружаем SQL файлы в правильном порядке
    print_info "1. 📥 Загрузка structure.sql..."
    if docker exec -i ua.postgres psql -U $POSTGRES_DB_USER -d $POSTGRES_DB < ua/structure.sql; then
        print_success "structure.sql успешно загружен"
    else
        print_error "Ошибка при загрузке structure.sql"
        return 1
    fi

    print_info "2. 📥 Загрузка specific_information.sql..."
    if docker exec -i ua.postgres psql -U $POSTGRES_DB_USER -d $POSTGRES_DB < ua/specific_information.sql; then
        print_success "specific_information.sql успешно загружен"
    else
        print_error "Ошибка при загрузке specific_information.sql"
        return 1
    fi

    print_success "=== Все SQL файлы успешно загружены в PostgreSQL! ==="
    return 0
}

# Функция запуска всех сервисов
start_services() {
    if ! ensure_docker; then
        return 1
    fi

    print_info "=== 🚀 Запуск всех сервисов ==="
    cd ua && docker compose up -d && cd ..
    print_success "Все сервисы запущены"
}

# Функция остановки всех сервисов
stop_services() {
    if ! ensure_docker; then
        return 1
    fi

    print_info "=== 🛑 Остановка всех сервисов ==="
    cd ua && docker compose down && cd ..
    print_success "Все сервисы остановлены"
}

# Функция показа статуса сервисов
show_status() {
    if ! ensure_docker; then
        return 1
    fi

    print_info "=== 📊 Статус сервисов ==="

    echo "Основные сервисы:"
    cd ua && docker compose ps --services 2>/dev/null | while read service; do
        if [ "$service" != "vault" ]; then
            docker compose ps $service
        fi
    done && cd ..

    echo ""
    echo "Vault:"
    docker compose -f ua/docker-compose.vault.yml ps vault
}

# Функция проверки состояния системы
check_system() {
    print_info "=== 🔍 Проверка состояния системы ==="

    # Проверка статуса Docker
    check_docker_status

    # Проверка сети (только если Docker установлен)
    if command -v docker &> /dev/null; then
        if docker network inspect ua-dev >/dev/null 2>&1; then
            print_success "Сеть ua-dev: создана"
        else
            print_warning "Сеть ua-dev: не создана"
        fi
    else
        print_warning "Сеть ua-dev: проверка невозможна (Docker не установлен)"
    fi

    # Проверка файлов
    if [ -f ua/.env ]; then
        print_success "Файл ua/.env: существует"
        # Проверка Vault токена
        source ua/.env
        if [ -n "$VAULT_TOKEN" ] && [ "$VAULT_TOKEN" != "" ]; then
            print_success "Vault токен: установлен"
        else
            print_warning "Vault токен: не установлен"
        fi
    else
        print_warning "Файл ua/.env: отсутствует"
    fi

    if [ -f initconfig.txt ]; then
        print_success "Файл initconfig.txt: существует"
    else
        print_warning "Файл initconfig.txt: отсутствует"
    fi

    # Проверка SQL файлов - ИСПРАВЛЕНО: правильные пути
    if [ -f "ua/structure.sql" ]; then
        print_success "Файл structure.sql: существует"
    else
        print_warning "Файл structure.sql: отсутствует"
    fi

    if [ -f "ua/specific_information.sql" ]; then
        print_success "Файл specific_information.sql: существует"
    else
        print_warning "Файл specific_information.sql: отсутствует"
    fi
}

# Главное меню
show_menu() {
    echo ""
    print_info "=== 🎛️  Менеджер развертывания UniArch ==="
    echo ""
    echo "1. 🐳 Установить Docker"
    echo "2. 🔐 Войти в Yandex Container Registry"
    echo "3. 🌐 Создать сеть ua-dev"
    echo "4. 📝 Инициализация из initconfig.txt"
    echo "5. 🔐 Настройка Vault"
    echo "6. 🚀 Запуск всех сервисов"
    echo "7. 📥 Загрузить SQL файлы в PostgreSQL"
    echo "8. 🛑 Остановка всех сервисов"
    echo "9. 📊 Показать статус сервисов"
    echo "10. 🔍 Проверить состояние системы"
    echo "100. 🔄 Полная настройка (все этапы)"
    echo "0. ❌ Выход"
    echo ""
}

# Основной цикл программы
main() {
    # Автоматически проверяем статус Docker при запуске
    check_docker_status

    # Проверяем наличие необходимых файлов
    if ! check_required_files; then
        print_error "Не удалось продолжить из-за отсутствия файлов"
        exit 1
    fi

    while true; do
        show_menu
        read -p "Выберите действие [0-10, 100]: " choice

        case $choice in
            1)
                print_info "=== 🐳 Установка Docker ==="
                read -p "Установить Docker? (y/N): " -n 1 -r
                echo
                if [[ $REPLY =~ ^[Yy]$ ]]; then
                    install_docker
                else
                    print_info "Установка Docker отменена"
                fi
                ;;
            2)
                docker_login
                ;;
            3)
                create_network
                ;;
            4)
                init_from_config
                ;;
            5)
                setup_vault
                ;;
            6)
                start_services
                ;;
            7)
                load_sql_files
                ;;
            8)
                stop_services
                ;;
            9)
                show_status
                ;;
            10)
                check_system
                ;;
            100)
                print_info "Запуск полной настройки..."
                if command -v docker &> /dev/null && command -v docker-compose &> /dev/null; then
                    create_network
                    init_from_config && docker_login   && setup_vault && start_services && load_sql_files
                else
                    print_error "Невозможно выполнить полную настройку: Docker не установлен"
                    print_info "Сначала установите Docker используя пункт 1"
                fi
                ;;
            0)
                print_info "Выход..."
                exit 0
                ;;
            *)
                print_error "Неверный выбор. Попробуйте снова."
                ;;
        esac

        echo ""
        read -p "Нажмите Enter чтобы продолжить..."
    done
}

# Запуск основной программы
main
