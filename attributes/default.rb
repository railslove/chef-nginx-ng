set[:passenger][:root] = "/usr/lib/phusion-passenger"
set[:passenger][:www_dir] = "/srv/www"
set[:passenger][:ruby_version] = "1.9.1"
set[:passenger][:min_instances] = 1;
set[:passenger][:max_pool_size] = 6;
set[:passenger][:spawn_method] = "smart";
set[:passenger][:passenger_friendly_error_pages] = "off";
set[:passenger][:passenger_load_shell_envvars] = "off";
set[:passenger][:passenger_show_version_in_header] = "off";

case platform
when "debian","ubuntu"
  set[:nginx_ng][:dir]     = "/etc/nginx"
  set[:nginx_ng][:log_dir] = "/var/log/nginx"
  set[:nginx_ng][:user]    = "www-data"
  set[:nginx_ng][:binary]  = "/usr/sbin/nginx"
else
  set[:nginx_ng][:dir]     = "/etc/nginx"
  set[:nginx_ng][:log_dir] = "/var/log/nginx"
  set[:nginx_ng][:user]    = "www-data"
  set[:nginx_ng][:binary]  = "/usr/sbin/nginx"
end

# set Strict Transport Security Headers
set[:nginx_ng][:hsts_headers] = "max-age=31536000";
# set X-Frame-Otions Header
set[:nginx_ng][:x_frame_options] = "SAMEORIGIN";
# do not expose version of nginx
set[:nginx_ng][:server_tokens] = "off";
# Specifies the maximum accepted body size of a client request, as indicated by the request header Content-Length.
set[:nginx_ng][:client_max_body_size] = "50M"
# If the request body size is more than the buffer size, then the entire (or partial) request body is written into a temporary file.
set[:nginx_ng][:client_body_buffer_size] = "128k"
# This directive assigns a timeout for the connection to the upstream server.
# It is necessary to keep in mind that this time out cannot be more than 75 seconds.
set[:nginx_ng][:proxy_connect_timeout] = 75
# This directive assigns timeout with the transfer of request to the upstream server.
set[:nginx_ng][:proxy_send_timeout] = 90
# This directive sets the read timeout for the response of the proxied server.
set[:nginx_ng][:proxy_read_timeout] = 90
# This directive activate response buffering of the proxied server.
set[:nginx_ng][:proxy_buffer_size] = "4k"
# This directive sets the number and the size of buffers, into which will be read the answer, obtained from the proxied server.
set[:nginx_ng][:proxy_buffers] = "4 32k"
set[:nginx_ng][:proxy_busy_buffers_size] = "64k"
# Sets the amount of data that will be flushed to the proxy_temp_path when writing.
set[:nginx_ng][:proxy_temp_file_write_size] = "64k"
# This directive sets the text, which must be changed in response-header "Location" and "Refresh" in the response of the proxied server.
set[:nginx_ng][:proxy_redirect] = "off"

# Sets the types and sizes of caches that store session parameters.
set[:nginx_ng][:ssl_session_cache] = ["shared:SSL:50m"]
# Specifies a time during which a client may reuse the session parameters stored in a cache.
set[:nginx_ng][:ssl_session_timeout] = "5m"

set[:nginx_ng][:ssl_protocols] = ["TLSv1", "TLSv1.1", "TLSv1.2"]
set[:nginx_ng][:ssl_ciphers]   = ["ECDHE-RSA-AES256-GCM-SHA384", "ECDHE-RSA-AES128-GCM-SHA256", "DHE-RSA-AES256-GCM-SHA384", "DHE-RSA-AES128-GCM-SHA256", "ECDHE-RSA-AES256-SHA384", "ECDHE-RSA-AES128-SHA256", "ECDHE-RSA-AES256-SHA", "ECDHE-RSA-AES128-SHA", "DHE-RSA-AES256-SHA256", "DHE-RSA-AES128-SHA256", "DHE-RSA-AES256-SHA", "DHE-RSA-AES128-SHA", "ECDHE-RSA-DES-CBC3-SHA", "EDH-RSA-DES-CBC3-SHA", "AES256-GCM-SHA384", "AES128-GCM-SHA256", "AES256-SHA256", "AES128-SHA256", "AES256-SHA", "AES128-SHA", "DES-CBC3-SHA", "HIGH", "!aNULL", "!eNULL", "!EXPORT", "!DES", "!MD5", "!PSK", "!RC4"]
set[:nginx_ng][:ssl_prefer_server_ciphers] = "on"
set[:nginx_ng][:format_blacklist] = [".php", ".aspx", ".asp", ".cgi", "myadmin", "webdav"]
set[:nginx_ng][:log_formats] = {
  "graylog" => "$remote_addr - $remote_user [$time_local] \"$request\" $status $body_bytes_sent \"$http_referer\" \"$http_user_agent\" \"$http_x_forwarded_for\" <msec=$msec|connection=$connection|connection_requests=$connection_requests|millis=$request_time>"
}
