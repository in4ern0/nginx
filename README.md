#### Nginx for RHEL
```
server {
    listen 80;
    server_name ilkin.com;

    location / {
        proxy_set_header   X-Forwarded-For $remote_addr;
        proxy_set_header   Host $http_host;
        proxy_pass         "http://127.0.0.1:9090";
    }
}

server {
    listen 81 default_server;
    listen [::]:81 default_server;

    server_name ilkin.com;


    location /health {
            access_log off;
            return 200 "healthy\n";
    }

    location / {
            proxy_pass http://localhost:9090;
            proxy_http_version 1.1;
            proxy_set_header Upgrade $http_upgrade;
            proxy_set_header Connection 'upgrade';
            proxy_set_header Host $host;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_cache_bypass $http_upgrade;
    }
 }



server {
    listen 82 default_server;
    listen [::]:82 default_server;

    server_name ilkin.com;

    location / {
        proxy_pass http://127.0.0.1:8080;
    }

    location /dilim {
        rewrite ^/dilim(.*) /$1 break;
        proxy_pass http://127.0.0.1:9090;
    }

    location /mail {
        rewrite ^/mail(.*) /$1 break;
        proxy_pass http://127.0.0.1:8282;
    }
}



#Restrict


server {
    listen 80;

    server_name example.com www.example.com;

    auth_basic "Restricted Access";
    auth_basic_user_file /etc/nginx/htpasswd.users;

    location / {
        proxy_pass http://localhost:5601;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }
}


server {
    listen 80;
    listen [::]:80;
    server_name 192.168.1.1 example.com;
    return 301 https://example.com$request_uri;
    # To allow special characters in headers
    ignore_invalid_headers off;
    # Allow any size file to be uploaded.
    # Set to a value such as 1000m; to restrict file size to a specific value
    client_max_body_size 1000m;
    # To disable buffering
    proxy_buffering off;

}

server {
    listen 443 ssl;
    server_name 192.168.1.1 example.com;
    ssl_certificate     /etc/mydir/certs/public.crt;
    ssl_certificate_key /etc/mydir/certs/private.key;
    ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
    ssl_dhparam  /etc/ssl/certs/dhparam.pem

    location / {
        proxy_set_header   X-Forwarded-For $remote_addr;
        proxy_set_header   Host $http_host;
        proxy_pass         "https://127.0.0.1:9000";
    }
}



<VirtualHost *:*>
        #ServerName  www.backend.com
        ServerAdmin webmaster@localhost
        DocumentRoot /var/www/html
        ServerAlias www.example.com
        SSLEngine on
        SSLCertificateFile /etc/apache2/public.crt
        SSLCertificateKeyFile /etc/apache2/private.key
        ProxyPreserveHost On
        ProxyPass / http://10.0.0.0:8080/
        #ProxyPassReverse / http://0.0.0.0:8080/
        ErrorLog ${APACHE_LOG_DIR}/error.log
        CustomLog ${APACHE_LOG_DIR}/access.log combined

</VirtualHost>








```
