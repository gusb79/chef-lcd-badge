#
# Cookbook:: tomcat
# Recipe:: tomcat-users
#
# Copyright:: 2018, The Authors, All Rights Reserved.
service 'tomcat' do
  action :nothing
end

# Context file for the manager application
cookbook_file 'context.xml' do
  path '/opt/tomcat/webapps/manager/META-INF/context.xml'
  owner node['server']['user']
  group node['server']['group']
  mode '0750'
end

# Context file for the host-manager application
cookbook_file 'context.xml' do
  path '/opt/tomcat/webapps/host-manager/META-INF/context.xml'
  owner node['server']['user']
  group node['server']['group']
  mode '0750'
end

template 'tomcat-users' do
  source 'tomcat-users.xml.erb'
  path '/opt/tomcat/conf/tomcat-users.xml'
  owner node['server']['user']
  group node['server']['group']
  mode '0750'
  variables(adminUser: node['server']['admin_username'], adminPassword: node['server']['admin_password'])
  notifies :restart, 'service[tomcat]', :immediately
end
