#!/bin/bash
cat - > /nginx.conf <<EOF
events {
}

user root;
http {
    error_log /dev/stdout info;
    access_log /dev/stdout;
    server {
        listen        $1;
        ssl on;

        ssl_certificate      $2;
        ssl_certificate_key  $3;
        ssl_client_certificate $4;
        ssl_verify_client on;

        location / {
            proxy_pass http://unix:$5:/;
        }
        location /version {
            return 200 '{"Version":"1.11.2-cs5","ApiVersion":"1.23","GitCommit":"d364ea1","GoVersion":"go1.5.4","Os":"linux","Arch":"amd64","KernelVersion":"4.4.21-rancher","BuildTime":"2016-09-13T15:26:43.575560244+00:00"}';
        }
    }
}
EOF

nginx -c /nginx.conf -g 'daemon off;'
