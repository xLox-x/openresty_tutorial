local redis = require "resty.redis_iresty"
 
local opts = {
	ip = "127.0.0.1",
	port = "6379",
	db_index = 1
}
 
local red = redis:new(opts)
 
local ok, err = red:set("dog", "an animal11111")
if not ok then
    ngx.say("failed to set dog: ", err)
    return
end
 
ngx.say("set result: ", ok)

red:init_pipeline()
red:set("cat", "Marry")
red:set("horse", "Bob")
red:get("cat")
red:get("dog")
red:get("horse")
local results, err = red:commit_pipeline()
if not results then
    ngx.say("failed to commit the pipelined requests: ", err)
    return
end
 
for i, res in ipairs(results) do
    ngx.say(res,"<br/>");
end