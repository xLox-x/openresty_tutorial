--[[
Author: 蒋本朋 jiangbenpeng@ceair.com
Date: 2025-09-30 08:53:26
LastEditors: 蒋本朋 jiangbenpeng@ceair.com
LastEditTime: 2025-09-30 08:53:54
FilePath: /dev_openresty/lua/decode_info.lua
Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AEn
--]]
local json = require "cjson"

ngx.req.read_body()
local args = ngx.req.get_post_args()

if not args or not args.info then
    ngx.exit(ngx.HTTP_BAD_REQUEST)
end

local client_ip = ngx.var.remote_addr
local user_agent = ngx.req.get_headers()['user-agent'] or ''
local info = ngx.decode_base64(args.info)

local response = {}
response.info = info
response.ip= client_ip
response.user_agent = user_agent

ngx.say(json.encode(response))

