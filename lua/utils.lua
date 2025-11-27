-- utils.lua
-- Utility functions for Lua scripts in OpenResty 

-- This file provides a function to print a table in a readable format.
function sayTable(t)
  for key, val in pairs(t) do
    if type(val) == "table" then
      ngx.say(key, ':', table.concat(val, ","))
    else
      ngx.say(key, ':', val)
    end
  end
end

return {
  sayTable = sayTable
}