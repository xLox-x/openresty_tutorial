--[[
Author: 蒋本朋 jiangbenpeng@ceair.com
Date: 2025-09-26 13:19:29
LastEditors: 蒋本朋 jiangbenpeng@ceair.com
LastEditTime: 2025-09-26 13:21:42
FilePath: /dev_open/lua/get_random_string.lua
Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
--]]
local args = ngx.req.get_uri_args()
local salt = args.salt
if not salt then
  ngx.exit(ngx.HTTP_BAD_REQUEST)
end

local string = ngx.md5(ngx.time() .. salt)
ngx.say(string)