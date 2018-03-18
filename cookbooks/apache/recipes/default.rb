#
# Cookbook:: apache
# Recipe:: default
#
# Copyright:: 2018, The Authors, All Rights Reserved.
include_recipe 'java::default'

package 'yum-utils'

package 'curl'

package 'httpd'

template 'index.html.erb' do
  path '/var/www/html/index.html'
  variables(author: node['apache']['author'], ip_address: node['ipaddress'])
end

service 'httpd' do
  action [ :enable, :start ]
end

template 'httpd.conf.erb' do
  path '/etc/httpd/conf/httpd.conf'
  variables(port: node['apache']['port'])
  notifies :restart, 'service[httpd]', :immediately
end
