#!/bin/bash

echo "=== Creazione VirtualHost per Laravel ==="

read -p "➡️  ServerName (es: myproject.test): " SERVER_NAME
read -p "➡️  ServerAlias (opzionale, separa con spazi): " SERVER_ALIAS
read -p "➡️  Directory progetto Laravel (es: /var/www/myproject): " PROJECT_DIR
read -p "➡️  Versione PHP da usare [default: 8.3]: " PHP_VERSION
PHP_VERSION=${PHP_VERSION:-8.3}

SOCKET_PATH="/run/php/php${PHP_VERSION}-fpm.sock"

# Controllo esistenza PHP
if [ ! -e "$SOCKET_PATH" ]; then
    echo "⚠️  PHP ${PHP_VERSION} non sembra installato o il socket $SOCKET_PATH non esiste."

    read -p "❓ Vuoi installare PHP ${PHP_VERSION} e php-fpm? [y/n] " INSTALL_PHP

    if [[ "$INSTALL_PHP" =~ ^[Yy]$ ]]; then
        echo "📦 Installazione PHP $PHP_VERSION..."
        sudo add-apt-repository ppa:ondrej/php -y
        sudo apt update
        sudo apt install php${PHP_VERSION} php${PHP_VERSION}-fpm -y
        echo "✅ PHP $PHP_VERSION installato."
    else
        echo "⛔ Interrotto. Installa PHP $PHP_VERSION manualmente e riprova."
        exit 1
    fi
fi

CONF_PATH="/etc/apache2/sites-available/${SERVER_NAME}.conf"

echo "📁 Generazione file VirtualHost: $CONF_PATH"

sudo bash -c "cat > $CONF_PATH" <<EOL
<VirtualHost *:80>
    ServerName $SERVER_NAME
    ServerAlias $SERVER_ALIAS
    DocumentRoot ${PROJECT_DIR}/public

    <Directory ${PROJECT_DIR}>
        AllowOverride All
        Require all granted
    </Directory>

    <FilesMatch \.php$>
        SetHandler "proxy:unix:/run/php/php${PHP_VERSION}-fpm.sock|fcgi://localhost"
    </FilesMatch>

    ErrorLog \${APACHE_LOG_DIR}/${SERVER_NAME}_error.log
    CustomLog \${APACHE_LOG_DIR}/${SERVER_NAME}_access.log combined
</VirtualHost>
EOL

echo "✅ VirtualHost creato."

# Abilita il sito
sudo a2ensite "${SERVER_NAME}.conf"

# Ricarica Apache
sudo systemctl reload apache2

echo "🚀 Fatto! Il sito è ora disponibile su http://${SERVER_NAME}"
