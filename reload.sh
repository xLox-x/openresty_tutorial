#! /bin/sh

nginx -s reload -p `pwd`/ -c $1

