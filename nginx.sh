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
        ssl_verify_client off;

        location / {
            proxy_pass http://unix:$5:;
        }
        location /v1.22/version {
            proxy_set_header Accept-Encoding "";
            proxy_pass http://unix:/var/run/docker.sock:;
            sub_filter_once off;
            sub_filter_types application/json;
            sub_filter '1.11.2' '1.11.2-cs5';
        }
        location /v1.22/info {
            proxy_set_header Accept-Encoding "";
            proxy_pass http://unix:/var/run/docker.sock:;
            sub_filter_once off;
            sub_filter_types application/json;
            sub_filter '1.11.2' '1.11.2-cs5';
        }
    }
}
EOF

nginx -c /nginx.conf -g 'daemon off;'
