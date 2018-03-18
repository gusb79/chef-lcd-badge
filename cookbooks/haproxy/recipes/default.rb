#
# Cookbook:: haproxy
# Recipe:: default
#
# Copyright:: 2018, The Authors, All Rights Reserved.
package 'haproxy'

service 'haproxy' do
  action [ :enable, :start ]
end

template 'haproxy.cfg.erb' do
  path '/etc/haproxy/haproxy.cfg'
  notifies :restart, 'service[haproxy]', :immediately
end
