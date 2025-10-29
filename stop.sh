#! /bin/sh

nginx -s stop -p `pwd`/ -c conf/nginx.conf

