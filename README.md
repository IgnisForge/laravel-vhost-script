# Laravel VirtualHost Creation Script

## Features

- Creates an Apache VirtualHost for a Laravel project.
- Configures the VirtualHost to use PHP-FPM.
- Allows specifying:
  - `ServerName` and optional `ServerAlias`
  - Project directory
  - PHP version (default: 8.3)
- Installs PHP and PHP-FPM if not already available.
- Enables the site and reloads Apache automatically.

## Requirements

- Ubuntu/Debian system
- Apache2 installed
- sudo privileges


## Usage

1. Make the script executable:

```bash
chmod +x create_laravel_vhost.sh
```

2. Run the script:

```bash
./create_laravel_vhost.sh
```

The script will automatically:

- Check if the specified PHP version is installed.

- Offer to install PHP and PHP-FPM if missing.

- Create the Apache VirtualHost configuration.

- Enable the new site and reload Apache.

## VirtualHost Configuration

The generated VirtualHost will look like this:
```
<VirtualHost *:80>
    ServerName your-server-name
    ServerAlias your-server-alias
    DocumentRoot /path/to/laravel/public

    <Directory /path/to/laravel>
        AllowOverride All
        Require all granted
    </Directory>

    <FilesMatch \.php$>
        SetHandler "proxy:unix:/run/php/phpX.Y-fpm.sock|fcgi://localhost"
    </FilesMatch>

    ErrorLog ${APACHE_LOG_DIR}/your-server-name_error.log
    CustomLog ${APACHE_LOG_DIR}/your-server-name_access.log combined
</VirtualHost>
```

- Replaces X.Y with the specified PHP version.

- Sets the DocumentRoot to the public folder of the Laravel project.

- Enables .htaccess overrides with AllowOverride All.

- Logs are stored in the Apache log directory.



## Notes
Make sure `/etc/hosts` includes an entry for your ServerName if using a local development domain.

The script requires add-apt-repository for PHP installation. Install it with:

```bash
sudo apt install software-properties-common -y
```

The script assumes Apache uses PHP-FPM with UNIX sockets.

## Example

```bash
➡️  ServerName: myproject.test
➡️  ServerAlias: www.myproject.test
➡️  Directory progetto Laravel: /var/www/myproject
➡️  Versione PHP da usare [default: 8.3]: 8.3
```

After running, your Laravel site will be available at:


```bash
http://myproject.test
```
