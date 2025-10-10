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

# Функция обновления переменной в initconfig.txt
update_config_var() {
    local var_name="$1"
    local var_value="$2"
    
    # Если файла нет - создаем
    if [ ! -f "initconfig.txt" ]; then
        touch initconfig.txt
    fi
    
    # Создаем временный файл
    local temp_file=$(mktemp)
    
    # Удаляем старую запись этой переменной если есть
    if grep -q "^$var_name=" initconfig.txt; then
        grep -v "^$var_name=" initconfig.txt > "$temp_file" 2>/dev/null || true
        # Добавляем новое значение
        echo "$var_name=$var_value" >> "$temp_file"
        # Заменяем оригинальный файл
        mv "$temp_file" initconfig.txt
        print_success "Обновлено: $var_name=$var_value"
    else
        # Просто добавляем новую переменную
        echo "$var_name=$var_value" >> initconfig.txt
        print_success "Добавлено: $var_name=$var_value"
    fi
}

# Функция проверки и запроса переменных
check_and_request_variables() {
    print_info "=== 🔍 Проверка конфигурации ==="
    
    # Проверяем наличие initconfig.txt
    if [ ! -f "initconfig.txt" ]; then
        print_warning "initconfig.txt не найден, создаем новый"
        touch initconfig.txt
    fi
    
    # Загружаем существующие переменные
    if [ -f "initconfig.txt" ]; then
        source initconfig.txt
    fi
    
    local updated=false
    
    # Проверяем KEYCLOAK_URL
    if [ -z "${KEYCLOAK_URL:-}" ]; then
        print_warning "KEYCLOAK_URL не установлен"
        read -p "Введите URL Keycloak (например: https://uabrkktest.unic.chat): " KEYCLOAK_URL
        if [ -n "$KEYCLOAK_URL" ]; then
            update_config_var "KEYCLOAK_URL" "$KEYCLOAK_URL"
            updated=true
        else
            print_error "KEYCLOAK_URL обязателен для работы"
            return 1
        fi
    else
        print_success "KEYCLOAK_URL: $KEYCLOAK_URL"
    fi
    
    # Проверяем KEYCLOAK_SERVER_IP
    if [ -z "${KEYCLOAK_SERVER_IP:-}" ]; then
        print_warning "KEYCLOAK_SERVER_IP не установлен"
        read -p "Введите IP сервера Keycloak [по умолчанию: 127.0.0.1]: " KEYCLOAK_SERVER_IP
        KEYCLOAK_SERVER_IP=${KEYCLOAK_SERVER_IP:-127.0.0.1}
        update_config_var "KEYCLOAK_SERVER_IP" "$KEYCLOAK_SERVER_IP"
        updated=true
    else
        print_success "KEYCLOAK_SERVER_IP: $KEYCLOAK_SERVER_IP"
    fi
    
    # Проверяем VITE_HOST_URL для UniArch
    if [ -z "${VITE_HOST_URL:-}" ]; then
        print_warning "VITE_HOST_URL не установлен"
        read -p "Введите URL UniArch (например: https://uabrtest.unic.chat/api): " VITE_HOST_URL
        if [ -n "$VITE_HOST_URL" ]; then
            update_config_var "VITE_HOST_URL" "$VITE_HOST_URL"
            updated=true
        else
            print_error "VITE_HOST_URL обязателен для работы UniArch"
            return 1
        fi
    else
        print_success "VITE_HOST_URL: $VITE_HOST_URL"
    fi
    
    # Проверяем UNICARCH_SERVER_IP
    if [ -z "${UNICARCH_SERVER_IP:-}" ]; then
        print_warning "UNICARCH_SERVER_IP не установлен"
        read -p "Введите IP сервера UniArch [по умолчанию: 127.0.0.1]: " UNICARCH_SERVER_IP
        UNICARCH_SERVER_IP=${UNICARCH_SERVER_IP:-127.0.0.1}
        update_config_var "UNICARCH_SERVER_IP" "$UNICARCH_SERVER_IP"
        updated=true
    else
        print_success "UNICARCH_SERVER_IP: $UNICARCH_SERVER_IP"
    fi
    
    # Проверяем EMAIL для SSL (опционально)
    if [ -z "${SSL_EMAIL:-}" ]; then
        print_warning "SSL_EMAIL не установлен (нужен для certbot)"
        read -p "Введите email для SSL сертификатов [можно пропустить]: " SSL_EMAIL
        if [ -n "$SSL_EMAIL" ]; then
            update_config_var "SSL_EMAIL" "$SSL_EMAIL"
            updated=true
        else
            print_warning "SSL_EMAIL не установлен, certbot может запросить email позже"
        fi
    else
        print_success "SSL_EMAIL: $SSL_EMAIL"
    fi
    
    if [ "$updated" = true ]; then
        print_success "Конфигурация обновлена"
    fi
    
    # Перезагружаем переменные
    source initconfig.txt
    
    return 0
}

# Функция проверки и установки nginx
setup_nginx() {
    print_info "=== 🌐 Проверка и установка nginx ==="
    
    if command -v nginx &> /dev/null; then
        print_success "nginx уже установлен"
        nginx -v
    else
        print_info "Установка nginx..."
        sudo apt update
        sudo apt install -y nginx
        print_success "nginx установлен"
    fi
    
    # Проверяем статус nginx
    if sudo systemctl is-active --quiet nginx; then
        print_success "nginx запущен"
    else
        print_info "Запуск nginx..."
        sudo systemctl start nginx
        sudo systemctl enable nginx
        print_success "nginx запущен и добавлен в автозагрузку"
    fi
}

# Функция проверки и установки certbot
setup_certbot() {
    print_info "=== 🔐 Проверка и установка certbot ==="
    
    if command -v certbot &> /dev/null; then
        print_success "certbot уже установлен"
    else
        print_info "Установка certbot..."
        sudo apt update
        sudo apt install -y certbot python3-certbot-nginx
        print_success "certbot установлен"
    fi
}

# Функция настройки Keycloak nginx конфига
setup_keycloak_config() {
    print_info "=== ⚙️ Настройка Keycloak nginx конфигурации ==="
    
    # Проверяем и запрашиваем переменные
    check_and_request_variables || return 1
    
    # Извлекаем домен из URL
    KEYCLOAK_DOMAIN=$(echo "$KEYCLOAK_URL" | sed 's|https://||')
    
    print_info "Домен Keycloak: $KEYCLOAK_DOMAIN"
    print_info "IP Keycloak сервера: $KEYCLOAK_SERVER_IP"
    
    # Проверяем наличие исходного конфига
    if [ ! -f "nginx/keycloak.conf" ]; then
        print_error "nginx/keycloak.conf не найден"
        print_info "Создайте файл nginx/keycloak.conf с конфигурацией"
        return 1
    fi
    
    # Создаем модифицированный конфиг
    print_info "Создание Keycloak nginx конфига..."
    
    # Временный файл для модификаций
    TEMP_CONF=$(mktemp)
    
    # Заменяем значения в конфиге
    sed \
        -e "s|set \$keycloak_server KEYCLOAK_SERVER_IP;|set \$keycloak_server $KEYCLOAK_SERVER_IP;|g" \
        -e "s|server_name keycloak.yourdomain;|server_name $KEYCLOAK_DOMAIN;|g" \
        -e "s|keycloak.yourdomain|$KEYCLOAK_DOMAIN|g" \
        nginx/keycloak.conf > "$TEMP_CONF"
    
    # Копируем конфиг в nginx
    sudo cp "$TEMP_CONF" "/etc/nginx/sites-available/keycloak"
    
    # Активируем конфиг
    if [ ! -f "/etc/nginx/sites-enabled/keycloak" ]; then
        sudo ln -s /etc/nginx/sites-available/keycloak /etc/nginx/sites-enabled/
    fi
    
    # Удаляем временный файл
    rm -f "$TEMP_CONF"
    
    print_success "Keycloak nginx конфиг создан и активирован"
    
    # Показываем изменения
    print_info "Выполненные замены для Keycloak:"
    print_info "  - KEYCLOAK_SERVER_IP → $KEYCLOAK_SERVER_IP"
    print_info "  - keycloak.yourdomain → $KEYCLOAK_DOMAIN"
}

# Функция настройки UniArch nginx конфига
setup_unicarch_config() {
    print_info "=== ⚙️ Настройка UniArch nginx конфигурации ==="
    
    # Проверяем и запрашиваем переменные
    check_and_request_variables || return 1
    
    # Извлекаем домен из URL (убираем /api)
    UNICARCH_DOMAIN=$(echo "$VITE_HOST_URL" | sed 's|https://||' | sed 's|/api||')
    
    print_info "Домен UniArch: $UNICARCH_DOMAIN"
    print_info "IP UniArch сервера: $UNICARCH_SERVER_IP"
    
    # Проверяем наличие исходного конфига
    if [ ! -f "nginx/unicarch.conf" ]; then
        print_error "nginx/unicarch.conf не найден"
        print_info "Создайте файл nginx/unicarch.conf с конфигурацией"
        return 1
    fi
    
    # Создаем модифицированный конфиг
    print_info "Создание UniArch nginx конфига..."
    
    # Временный файл для модификаций
    TEMP_CONF=$(mktemp)
    
    # Заменяем значения в конфиге
    sed \
        -e "s|set \$apphost 192.X.X.X;|set \$apphost $UNICARCH_SERVER_IP;|g" \
        -e "s|server_name unicarch.youdomain;|server_name $UNICARCH_DOMAIN;|g" \
        -e "s|unicarch.youdomain|$UNICARCH_DOMAIN|g" \
        nginx/unicarch.conf > "$TEMP_CONF"
    
    # Копируем конфиг в nginx
    sudo cp "$TEMP_CONF" "/etc/nginx/sites-available/unicarch"
    
    # Активируем конфиг
    if [ ! -f "/etc/nginx/sites-enabled/unicarch" ]; then
        sudo ln -s /etc/nginx/sites-available/unicarch /etc/nginx/sites-enabled/
    fi
    
    # Удаляем временный файл
    rm -f "$TEMP_CONF"
    
    print_success "UniArch nginx конфиг создан и активирован"
    
    # Показываем изменения
    print_info "Выполненные замены для UniArch:"
    print_info "  - 192.X.X.X → $UNICARCH_SERVER_IP"
    print_info "  - unicarch.youdomain → $UNICARCH_DOMAIN"
}

# Функция настройки всех nginx конфигов
setup_all_nginx_configs() {
    print_info "=== ⚙️ Настройка всех nginx конфигураций ==="
    
    # Создаем папку для nginx конфигов если нет
    sudo mkdir -p /etc/nginx/sites-available
    sudo mkdir -p /etc/nginx/sites-enabled
    
    setup_keycloak_config || return 1
    echo ""
    setup_unicarch_config || return 1
    
    print_success "Все nginx конфиги созданы и активированы"
}

# Функция обновления конфигурации nginx
update_nginx_config() {
    print_info "=== 🔄 Обновление конфигурации nginx ==="
    
    # Проверяем и запрашиваем переменные
    check_and_request_variables || return 1
    
    # Обновляем Keycloak конфиг
    if [ -f "nginx/keycloak.conf" ]; then
        print_info "Обновление Keycloak конфига..."
        KEYCLOAK_DOMAIN=$(echo "$KEYCLOAK_URL" | sed 's|https://||')
        
        TEMP_CONF=$(mktemp)
        sed \
            -e "s|set \$keycloak_server KEYCLOAK_SERVER_IP;|set \$keycloak_server $KEYCLOAK_SERVER_IP;|g" \
            -e "s|server_name keycloak.yourdomain;|server_name $KEYCLOAK_DOMAIN;|g" \
            -e "s|keycloak.yourdomain|$KEYCLOAK_DOMAIN|g" \
            nginx/keycloak.conf > "$TEMP_CONF"
        
        sudo cp "$TEMP_CONF" "/etc/nginx/sites-available/keycloak"
        rm -f "$TEMP_CONF"
        print_success "Keycloak конфиг обновлен"
    fi
    
    # Обновляем UniArch конфиг
    if [ -f "nginx/unicarch.conf" ]; then
        print_info "Обновление UniArch конфига..."
        UNICARCH_DOMAIN=$(echo "$VITE_HOST_URL" | sed 's|https://||' | sed 's|/api||')
        
        TEMP_CONF=$(mktemp)
        sed \
            -e "s|set \$apphost 192.X.X.X;|set \$apphost $UNICARCH_SERVER_IP;|g" \
            -e "s|server_name unicarch.youdomain;|server_name $UNICARCH_DOMAIN;|g" \
            -e "s|unicarch.youdomain|$UNICARCH_DOMAIN|g" \
            nginx/unicarch.conf > "$TEMP_CONF"
        
        sudo cp "$TEMP_CONF" "/etc/nginx/sites-available/unicarch"
        rm -f "$TEMP_CONF"
        print_success "UniArch конфиг обновлен"
    fi
    
    # Активируем конфиги если еще не активированы
    if [ ! -f "/etc/nginx/sites-enabled/keycloak" ] && [ -f "/etc/nginx/sites-available/keycloak" ]; then
        sudo ln -s /etc/nginx/sites-available/keycloak /etc/nginx/sites-enabled/
        print_success "Keycloak конфиг активирован"
    fi
    
    if [ ! -f "/etc/nginx/sites-enabled/unicarch" ] && [ -f "/etc/nginx/sites-available/unicarch" ]; then
        sudo ln -s /etc/nginx/sites-available/unicarch /etc/nginx/sites-enabled/
        print_success "UniArch конфиг активирован"
    fi
    
    print_success "Конфигурация nginx обновлена"
    
    # Проверяем конфигурацию
    if sudo nginx -t; then
        print_success "Конфигурация проверена успешно"
    else
        print_error "Ошибка в конфигурации nginx"
        return 1
    fi
}

# Функция получения SSL сертификатов
setup_ssl() {
    print_info "=== 📜 Настройка SSL сертификатов ==="
    
    # Проверяем переменные
    check_and_request_variables || return 1
    
    local ssl_updated=false
    local was_nginx_running=false
    
    # Проверяем, запущен ли nginx
    if sudo systemctl is-active --quiet nginx; then
        was_nginx_running=true
        print_info "nginx запущен, останавливаем для получения сертификатов..."
        sudo systemctl stop nginx
        print_success "nginx остановлен"
    else
        print_info "nginx уже остановлен"
    fi
    
    # SSL для Keycloak
    KEYCLOAK_DOMAIN=$(echo "$KEYCLOAK_URL" | sed 's|https://||')
    print_info "Получение SSL сертификата для Keycloak ($KEYCLOAK_DOMAIN)..."
    
    if sudo [ -d "/etc/letsencrypt/live/$KEYCLOAK_DOMAIN" ]; then
        print_success "SSL сертификат для Keycloak уже существует"
    else
        print_info "Запуск certbot в standalone режиме для Keycloak..."
        local certbot_cmd="sudo certbot certonly --standalone -d $KEYCLOAK_DOMAIN --non-interactive --agree-tos"
        
        if [ -n "${SSL_EMAIL:-}" ]; then
            certbot_cmd="$certbot_cmd --email $SSL_EMAIL"
        else
            certbot_cmd="$certbot_cmd --register-unsafely-without-email"
        fi
        
        if eval "$certbot_cmd"; then
            print_success "SSL сертификат для Keycloak получен"
            ssl_updated=true
        else
            print_error "Ошибка получения сертификата для Keycloak"
        fi
    fi
    
    # SSL для UniArch
    UNICARCH_DOMAIN=$(echo "$VITE_HOST_URL" | sed 's|https://||' | sed 's|/api||')
    print_info "Получение SSL сертификата для UniArch ($UNICARCH_DOMAIN)..."
    
    if sudo [ -d "/etc/letsencrypt/live/$UNICARCH_DOMAIN" ]; then
        print_success "SSL сертификат для UniArch уже существует"
    else
        print_info "Запуск certbot в standalone режиме для UniArch..."
        local certbot_cmd="sudo certbot certonly --standalone -d $UNICARCH_DOMAIN --non-interactive --agree-tos"
        
        if [ -n "${SSL_EMAIL:-}" ]; then
            certbot_cmd="$certbot_cmd --email $SSL_EMAIL"
        else
            certbot_cmd="$certbot_cmd --register-unsafely-without-email"
        fi
        
        if eval "$certbot_cmd"; then
            print_success "SSL сертификат для UniArch получен"
            ssl_updated=true
        else
            print_error "Ошибка получения сертификата для UniArch"
        fi
    fi
    
    # Запускаем nginx обратно если он был запущен
    if [ "$was_nginx_running" = true ]; then
        print_info "Запуск nginx..."
        if sudo systemctl start nginx; then
            print_success "nginx запущен"
        else
            print_error "Ошибка запуска nginx"
        fi
    fi
    
    # После получения сертификатов, обновляем конфиги nginx
    if [ "$ssl_updated" = true ]; then
        print_info "Обновление nginx конфигов с SSL путями..."
        update_nginx_config
    fi
    
    # Предлагаем обновить существующие сертификаты
    read -p "Обновить все SSL сертификаты? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        sudo certbot renew
        print_success "Все SSL сертификаты обновлены"
    fi
    
    print_success "Настройка SSL завершена"
}

# Функция проверки конфига nginx
test_nginx_config() {
    print_info "=== 🔍 Проверка конфигурации nginx ==="
    
    if sudo nginx -t; then
        print_success "Конфигурация nginx корректна"
        return 0
    else
        print_error "Ошибка в конфигурации nginx"
        return 1
    fi
}

# Функция перезагрузки nginx через restart
reload_nginx() {
    print_info "=== 🔄 Перезагрузка nginx ==="
    
    if sudo systemctl restart nginx; then
        print_success "nginx перезапущен"
        return 0
    else
        print_error "Не удалось перезапустить nginx"
        return 1
    fi
}

# Функция показа статуса
show_status() {
    print_info "=== 📊 Статус nginx ==="
    
    echo "Статус службы:"
    sudo systemctl status nginx --no-pager
    
    echo ""
    echo "Активные конфиги:"
    sudo ls -la /etc/nginx/sites-enabled/
    
    echo ""
    echo "SSL сертификаты:"
    if [ -f "initconfig.txt" ]; then
        source initconfig.txt
        if [ -n "${KEYCLOAK_URL:-}" ]; then
            KEYCLOAK_DOMAIN=$(echo "$KEYCLOAK_URL" | sed 's|https://||')
            echo "Keycloak ($KEYCLOAK_DOMAIN):"
            sudo certbot certificates | grep "$KEYCLOAK_DOMAIN" || echo "  Сертификат не найден"
        fi
        if [ -n "${VITE_HOST_URL:-}" ]; then
            UNICARCH_DOMAIN=$(echo "$VITE_HOST_URL" | sed 's|https://||' | sed 's|/api||')
            echo "UniArch ($UNICARCH_DOMAIN):"
            sudo certbot certificates | grep "$UNICARCH_DOMAIN" || echo "  Сертификат не найден"
        fi
    fi
}

# Главное меню
show_menu() {
    echo ""
    print_info "=== 🌐 Менеджер настройки nginx ==="
    echo ""

    echo "1. 🌐 Установка/проверка nginx"
    echo "2. 🔐 Установка/проверка certbot"
    echo "3. ⚙️ Настройка всех nginx конфигов"
    echo "4. 🔑 Настройка Keycloak конфига"
    echo "5. 🏢 Настройка UniArch конфига"
    echo "6. 🔄 Обновить все конфигурации"
    echo "7. 📜 Получение SSL сертификатов"
    echo "8. 🔍 Проверка конфигурации"
    echo "9. 🔄 Перезагрузить nginx"
    echo "10. 📊 Показать статус"
    echo "100. 🚀 Полная настройка nginx (конфигурационные файлы для UnicArch и KeyCloak)"
    echo "0. ❌ Выход"
    
    echo ""
}

# Функция полной настройки
full_setup() {
    print_info "=== 🚀 Полная настройка nginx ==="
    
    # Временно отключаем строгий режим для обработки ошибок
    set +e
    
    local success=true
    
    check_and_request_variables || success=false
    [ "$success" = true ] && setup_nginx || success=false
    [ "$success" = true ] && setup_certbot || success=false
    [ "$success" = true ] && setup_ssl || print_warning "Продолжаем несмотря на ошибки SSL"
    [ "$success" = true ] && setup_all_nginx_configs || success=false
    [ "$success" = true ] && test_nginx_config || success=false
    [ "$success" = true ] && reload_nginx || print_warning "Продолжаем несмотря на ошибки перезагрузки nginx"
    
    # Восстанавливаем строгий режим
    set -e
    
    if [ "$success" = true ]; then
        print_success "=== ✅ Настройка nginx завершена! ==="
    else
        print_warning "=== ⚠️ Настройка завершена с предупреждениями ==="
    fi
}

# Основной цикл программы
main() {
    while true; do
        show_menu
        read -p "Выберите действие [0-11]: " choice
        
        case $choice in
           
            1) setup_nginx ;;
            2) setup_certbot ;;
            3) setup_all_nginx_configs ;;
            4) setup_keycloak_config ;;
            5) setup_unicarch_config ;;
            6) update_nginx_config ;;
            7) setup_ssl ;;
            8) test_nginx_config ;;
            9) reload_nginx ;;
            10) show_status ;;
            100) full_setup ;;
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

# Обработка аргументов командной строки
case "${1:-}" in
    "--full")
        full_setup
        ;;
    "--status")
        show_status
        ;;
    "--setup")
        setup_all_nginx_configs
        test_nginx_config
        reload_nginx
        ;;
    "--update")
        update_nginx_config
        ;;
    *)
        main
        ;;
esac
