server {
    listen   443 ssl spdy;
    server_name mypigbank.com;
    ssl on;
    ssl_session_timeout 5m;
    ssl_stapling on;
    ssl_certificate        /etc/ssl/mypigbank/mypigbank.com.crt;
    ssl_certificate_key    /etc/ssl/mypigbank/mypigbank.com.key;

# Clickjacking protection: allow iframes from same origin
    add_header X-Frame-Options SAMEORIGIN;
    add_header Frame-Options SAMEORIGIN;
# Enforce HTTPS connection for all requests, including subdomains
    add_header Strict-Transport-Security "max-age=31536000; includeSubDomains";
# IE+ and variants, XSS Protection
    add_header X-XSS-Protection "1;mode=block";
# Protection from drive-by dynamic/executable IE files
    add_header X-Content-Type-Options nosniff;
# Strict Content Security Policy, deny all external requests
# for custom CSP headers use: http://cspbuilder.info
    add_header Content-Security-Policy "default-src 'self'; script-src 'self' 'unsafe-inline' 'unsafe-eval' https://ssl.google-analytics.com https://connect.facebook.net; img-src 'self' https://ssl.google-analytics.com https://s-static.ak.facebook.com; style-src 'self' 'unsafe-inline' https://fonts.googleapis.com; font-src 'self' https://themes.googleusercontent.com; frame-src https://www.facebook.com https://s-static.ak.facebook.com; object-src 'none'";

 

    root /home/www/mypigbank.com/html;
    index index.php index.html index.htm;

    location ~ \.php$ {

fastcgi_pass unix:/var/run/php5-fpm.sock;
        include fastcgi_params;
        fastcgi_param HTTPS on;

    }

    location ~ /\. {
        deny all;
    }
    location / {
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header HOST $http_host;
        proxy_set_header X-NginX-Proxy true;

        proxy_pass http://127.0.0.1:8082;
        proxy_redirect off;
    }


    access_log /home/www/shared/log/mypigbank.com-access.log;
    error_log /home/www/shared/log/mypigbank.com-error.log;
    error_page 404 /404.html;

}
