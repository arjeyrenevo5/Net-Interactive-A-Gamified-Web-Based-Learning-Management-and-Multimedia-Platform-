# Net Learn — plain PHP learning platform

Responsive computer-networking learning site built with plain PHP, PDO, MySQL/MariaDB, HTML, CSS, and JavaScript. No Laravel or other framework is required. Prepared for Nginx + PHP-FPM; it also runs in XAMPP.

## Nginx deployment (recommended)

1. Install Nginx, PHP 8.1+ FPM with `pdo_mysql` and `mbstring`, and MySQL/MariaDB.
2. Place this folder at `/var/www/net-learn` and import `setup.sql` into MySQL.
3. Create a dedicated DB user, grant it access to `net_learn`, and set PHP-FPM pool variables `DB_HOST`, `DB_NAME`, `DB_USER`, and `DB_PASSWORD` in the pool configuration. Restart PHP-FPM after editing. Do not use the MySQL root account on a public server.
4. Configure a site such as:

```nginx
server {
    listen 80;
    server_name your-domain.example;
    root /var/www/net-learn;
    index index.php;
    location / { try_files $uri $uri/ =404; }
    location ~ \.php$ {
        include fastcgi_params;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        fastcgi_pass unix:/run/php/php8.2-fpm.sock;
    }
    location ~ /\. { deny all; }
}
```

Use the PHP-FPM socket or address installed on your server. Set up HTTPS before public use. Nginx serves the PHP site through PHP-FPM; it does not require Apache or Laravel.

## XAMPP

Copy this directory to `C:\\xampp\\htdocs\\net-learn`, start Apache and MySQL, import `setup.sql` through phpMyAdmin, and open `http://localhost/net-learn/`. The local default database is `net_learn`, user `root`, blank password; change `config/database.php` or provide the DB environment variables if needed.

## First administrator

Register a normal account, then promote it in phpMyAdmin or the MySQL console:

```sql
UPDATE users SET role='admin' WHERE email='your-email@example.com';
```

Sign out and back in. Admin dashboard provides student listing, lesson/resource/lab management, quiz list, student results, and a printable report view. Student accounts are created through public registration.

## Included learner features

- Five networking lessons: fundamentals, OSI, IPv4 subnetting, VLANs, and routing
- Guided practice activities with a simple clickable LAN connection visual
- Curated multimedia/tool resources
- Three quizzes with explanations and saved attempts
- Student dashboard with completed lessons, labs, and quiz scores
- Admin overview, lesson/resource/activity creation, student/results views, and print-to-PDF reporting

To reset or update a fresh install, import `setup.sql`. Existing database content is preserved by the seed checks. This is a school-project starter and should receive a security review before handling real student data on a public server.
