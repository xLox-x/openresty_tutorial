-- To test JSON encoding in OpenResty
local json = require("cjson");
local person = {
    name = "John Doe",
    age = 30,
    email = "john.doe@example.com"
};

ngx.say("Person String: " .. json.encode(person));
ngx.say("\n");

-- To test JSON decoding in OpenResty
local person_string = [[ {"age":30,"email":"john.doe@example.com","name":"John Doe"} ]];
local decoded_person = json.decode(person_string);
ngx.say("Name: " .. decoded_person.name);
ngx.say("Age: " .. decoded_person.age);
ngx.say("Email: " .. decoded_person.email);

function json_decode(str)
    local status, result = pcall(json.decode, str);
    if status then
        return result;
    else
        ngx.log(ngx.ERR, "JSON decode error: " .. result);
        return nil;
    end
end

-- Test JSON decoding with error handling
ngx.say("\nTesting JSON decoding with error handling:\n");
local str = '{"name":"Alice","age":25,"city":"New York"}';
local decoded_str = json_decode(str);
ngx.say("-->", type(decoded_str), "\n");
if decoded_str == nil then
    ngx.say("Decoding failed.\n");
    return;
end
ngx.say("Name: " .. decoded_str.name);
ngx.say("Age: " .. decoded_str.age);
ngx.say("City: " .. decoded_str.city);

local safe_json = require("cjson.safe");
-- Test safe JSON decoding
ngx.say("\nTesting safe JSON decoding:\n");
local safe_str = '{"name":"Bob","age":28,"city":"Los Angeles}';
local safe_decoded_str, err = safe_json.decode(safe_str);
if err then
    ngx.say("Safe decoding failed: " .. err .. "\n");
    return;
end
ngx.say("Name: " .. safe_decoded_str.name);
ngx.say("Age: " .. safe_decoded_str.age);
ngx.say("City: " .. safe_decoded_str.city);

