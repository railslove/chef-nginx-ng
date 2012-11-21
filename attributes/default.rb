set[:passenger][:root] = "/usr/lib/phusion-passenger"
set[:passenger][:www_dir] = "/srv/www"
set[:passenger][:ruby_version] = "1.9.1"
set[:passenger][:min_instances] = 1;
set[:passenger][:spawn_method] = "smart";

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

set[:nginx_ng][:client_max_body_size] = "50M"
set[:nginx_ng][:client_body_buffer_size] = "128k"
set[:nginx_ng][:proxy_connect_timeout] = 90
set[:nginx_ng][:proxy_send_timeout] = 90
set[:nginx_ng][:proxy_read_timeout] = 90
set[:nginx_ng][:proxy_buffer_size] = "4k"
set[:nginx_ng][:proxy_buffers] = "4 32k"
set[:nginx_ng][:proxy_busy_buffers_size] = "64k"
set[:nginx_ng][:proxy_temp_file_write_size] = "64k"
set[:nginx_ng][:proxy_redirect] = "off"