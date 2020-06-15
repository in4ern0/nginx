
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
         
