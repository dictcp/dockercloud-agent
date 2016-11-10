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
        ssl_verify_client on;
        ssl_verify_depth 10;

        keepalive_timeout   70;

        location / {
            proxy_pass_header Server;
            proxy_http_version 1.1;
            proxy_pass http://unix:$5:;
        }

        # pretend we are using dockercloud engine
        location ~ ^(/v[0-9.]*)?/(version|info)$ {
            proxy_pass_header Server;
            proxy_http_version 1.1;
            proxy_set_header Accept-Encoding "";
            proxy_pass http://unix:$5:;

            subs_filter_types application/json;

            # for version/info resp: "Version":"1.11.2-cs5" | "ServerVersion": "1.11.2-cs5"
            subs_filter '1.11.2' '1.11.2-cs5';

            # for version resp: {"Version":"1.11.2-cs5","GitCommit":"d364ea1"}
            subs_filter 'GitCommit":"([0-9a-e]*)"' '"GitCommit":"d364ea1"';
        }
    }
}
EOF

nginx -c /nginx.conf -g 'daemon off;'
