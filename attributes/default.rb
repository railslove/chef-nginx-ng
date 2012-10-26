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