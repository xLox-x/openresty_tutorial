# First request (allowed)
curl http://localhost:8088
# Output: Hello from OpenResty + Redis! Your IP (127.0.0.1) is within the rate limit.

# Send 101 requests to trigger rate limit
for i in $(seq 1 101);  do curl -i http://localhost:8088; done
# The curl -i command is used to fetch a resource from a URL while including the HTTP response headers in the output. This is particularly useful for debugging or inspecting server responses.