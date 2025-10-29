#! /bin/sh

nginx -s reload -p `pwd`/ -c conf/nginx.conf

