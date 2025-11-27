local utils = require "lua/utils";
local args = ngx.req.get_uri_args()
utils.sayTable(args)