#!/bin/bash
cat - > /nginx.conf <<EOF
events {
}

user root;

http {
    error_log /dev/stdout info;
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
            # proxy_pass_header Server;
            # proxy_set_header Accept-Encoding "";
            # proxy_http_version 1.1;
            # proxy_pass http://unix:/var/run/docker.sock:;
            # sub_filter_once off;
            # sub_filter_types application/json;
            # sub_filter '1.11.2' '1.11.2-cs5';
            # sub_filter 'b9f10c9' 'd364ea1';
            return 200 '{"Version":"1.11.2-cs5","ApiVersion":"1.23","GitCommit":"d364ea1","GoVersion":"go1.5.4","Os":"linux","Arch":"amd64","KernelVersion":"4.4.21-rancher","BuildTime":"2016-09-13T15:26:43.575560244+00:00"}';
        }
        location /v1.22/version {
            # proxy_pass_header Server;
            # proxy_set_header Accept-Encoding "";
            # proxy_http_version 1.1;
            # proxy_pass http://unix:/var/run/docker.sock:;
            # sub_filter_once off;
            # sub_filter_types application/json;
            # sub_filter '1.11.2' '1.11.2-cs5';
            # sub_filter 'b9f10c9' 'd364ea1';
            return 200 '{"Version":"1.11.2-cs5","ApiVersion":"1.23","GitCommit":"d364ea1","GoVersion":"go1.5.4","Os":"linux","Arch":"amd64","KernelVersion":"4.4.21-rancher","BuildTime":"2016-09-13T15:26:43.575560244+00:00"}';
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
