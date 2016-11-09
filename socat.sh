#!/bin/bash
/usr/bin/socat openssl-listen:$1,reuseaddr,cert=$2,key=$3,cafile=$4,cipher=HIGH:!DH,method=TLS1,fork unix-connect:$5
