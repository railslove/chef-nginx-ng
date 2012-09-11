define :nginx_ng_web_app, :template => "default-site.conf.erb" do
  application_name = params[:name]
  application = params[:application]
  certificate = params[:certificate]

  template "#{node[:nginx_ng][:dir]}/sites-available/#{application_name}.conf" do
    source params[:template]
    owner "root"
    group "root"
    mode 0644
    if params[:cookbook]
      cookbook params[:cookbook]
    end
    variables(
      :application => application,
      :certificate => certificate,
      :application_name => application_name,
      :params => params
    )
    if ::File.exists?("#{node[:nginx_ng][:dir]}/sites-enabled/#{application_name}.conf")
      notifies :restart, resources(:service => "nginx"), :delayed
    end
  end

  if certificate
    directory "#{node[:nginx_ng][:dir]}/ssl/"
    %w(crt key).each do |ssl_attribute|
      file "#{node[:nginx_ng][:dir]}/ssl/#{certificate['id']}.#{ssl_attribute}" do
        owner "root"
        group "root"
        mode "0644"
        action :create
        content certificate[ssl_attribute]
      end
    end
  end

  nginx_ng_site "#{params[:name]}.conf" do
    enable enable_setting
  end
end