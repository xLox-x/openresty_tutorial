-- Rate limit rules
RATE_LIMIT = {
    requests = 100,    -- Max 100 requests
    window = 60,       -- Per 60 seconds (1 minute)
    message = "Too many requests, please try again later.",
    retry_after = 60   -- Retry after 60s
}

-- Redis connection settings
REDIS_CONFIG = {
    host = "127.0.0.1",  -- Your Redis host (replace with remote IP if needed)
    port = 6379,
    timeout = 1000,      -- 1s timeout (prevent hanging requests)
    password = "",       -- Add Redis password if set
    db = 0               -- Redis database number
}

-- Core Redis rate limiting function
function redis_rate_limit()
    -- Get client IP (supports proxies like Cloudflare)
    local ip = ngx.var.http_x_forwarded_for or ngx.var.remote_addr
    local redis_key = "rate_limit:" .. ip  -- Unique key per IP

    -- 1. Create Redis connection
    local redis = require "resty.redis"
    local red = redis:new()
    red:set_timeout(REDIS_CONFIG.timeout)

    -- Connect to Redis
    local ok, err = red:connect(REDIS_CONFIG.host, REDIS_CONFIG.port)
    if not ok then
        ngx.log(ngx.ERR, "Failed to connect to Redis: ", err)
        -- Fail open: allow request if Redis is down (optional: ngx.exit(500) to fail closed)
        return true
    end

    -- Authenticate if Redis has a password
    if REDIS_CONFIG.password ~= "" then
        local ok, err = red:auth(REDIS_CONFIG.password)
        if not ok then
            ngx.log(ngx.ERR, "Redis auth failed: ", err)
            red:close()
            return true
        end
    end

    -- Select Redis database
    red:select(REDIS_CONFIG.db)

    -- 2. Implement rate limiting logic
    local count, err = red:incr(redis_key)
    if err then
        ngx.log(ngx.ERR, "Redis incr failed for IP ", ip, ": ", err)
        red:close()
        return true
    end

    -- Set TTL on first request (auto-reset after window expires)
    if count == 1 then
        local ok, err = red:expire(redis_key, RATE_LIMIT.window)
        if not ok then
            ngx.log(ngx.ERR, "Redis expire failed for IP ", ip, ": ", err)
        end
    end

    -- 3. Check if rate limit is exceeded
    if count > RATE_LIMIT.requests then
        ngx.log(ngx.WARN, "Rate limit exceeded for IP ", ip, ": ", count, " requests")
        ngx.status = ngx.HTTP_TOO_MANY_REQUESTS
        ngx.header["Content-Type"] = "text/plain; charset=utf-8"
        ngx.header["Retry-After"] = RATE_LIMIT.retry_after
        ngx.say(RATE_LIMIT.message)
        
        -- Close Redis connection before exiting
        red:close()
        ngx.exit(ngx.HTTP_TOO_MANY_REQUESTS)
    end

    -- 4. Reuse Redis connection (connection pool for performance)
    local ok, err = red:set_keepalive(10000, 100)  -- 10s idle timeout, max 100 connections
    if not ok then
        ngx.log(ngx.ERR, "Failed to set keepalive: ", err)
        red:close()
    end

    -- Allow request to proceed
    return true
end
-- Rate limit middleware for OpenResty