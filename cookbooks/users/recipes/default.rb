# Cookbook:: users
# Recipe:: default
#
# Copyright:: 2018, The Authors, All Rights Reserved.
user 'chef' do
  password '$1$NPyYnO0C$XcN7DHsGyREp6ln5Jy4101'
end

service 'sshd' do
  action :nothing
end

cookbook_file '/etc/ssh/sshd_config' do
  source 'sshd_config'
  owner 'root'
  group 'root'
  mode '0644'
  notifies :restart, 'service[sshd]', :immediately
end
