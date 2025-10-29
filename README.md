# openresty_tutorial
Creating high performance API server for UNGIN in Lua

## Find process use port
sudo lsof -i tcp:8088

## Setup PATH
export PATH=/usr/local/openresty/nginx/sbin:$PATH

## Post
curl -i --data 'info=SGVsbG8gT3BlblJlc3R5' http://localhost:8088/decode_info