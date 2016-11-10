#!/bin/bash
cat - > /nginx.conf <<EOF
events {
}

user root;

http {
    error_log /dev/stderr;
    access_log /dev/stdout;
    default_type  application/json;
    server {
        listen $1 default_server ssl;

        ssl_certificate      $2;
        ssl_certificate_key  $3;
        ssl_client_certificate $4;
        ssl_verify_client off;

        keepalive_timeout   70;

        location / {
            proxy_pass_header Server;
            proxy_http_version 1.1;
            proxy_pass http://unix:$5:;
        }
        location /version {
            proxy_pass_header Server;
            proxy_set_header Accept-Encoding "";
            proxy_http_version 1.1;
            proxy_pass http://unix:/var/run/docker.sock:;
            sub_filter_once off;
            sub_filter_types application/json;
            sub_filter '1.11.2' '1.11.2-cs5';
            sub_filter 'b9f10c9' 'd364ea1';
        }
        location /v1.22/version {
            proxy_pass_header Server;
            proxy_set_header Accept-Encoding "";
            proxy_http_version 1.1;
            proxy_pass http://unix:/var/run/docker.sock:;
            sub_filter_once off;
            sub_filter_types application/json;
            sub_filter '1.11.2' '1.11.2-cs5';
            sub_filter 'b9f10c9' 'd364ea1';
        }
        location /info {
            proxy_pass_header Server;
            proxy_set_header Accept-Encoding "";
            proxy_http_version 1.1;
            proxy_pass http://unix:/var/run/docker.sock:;
            sub_filter_once off;
            sub_filter_types application/json;
            sub_filter '1.11.2' '1.11.2-cs5';
        }
        location /v1.22/info {
            proxy_pass_header Server;
            proxy_set_header Accept-Encoding "";
            proxy_http_version 1.1;
            proxy_pass http://unix:/var/run/docker.sock:;
            sub_filter_once off;
            sub_filter_types application/json;
            sub_filter '1.11.2' '1.11.2-cs5';
        }
    }
}
EOF

nginx -c /nginx.conf -g 'daemon off;'
