#
# Cookbook:: tomcat
# Recipe:: server
#
# Copyright:: 2018, The Authors, All Rights Reserved.

# ERROR: Node attributes are read-only when you do not specify which precedence
# level to set. To set an attribute use code like `node.default["key"] = "value"'
package 'java-1.7.0-openjdk-devel'

group node['server']['group']

user node['server']['user'] do
  group node['server']['group']
end

directory '/opt/tomcat' do
  owner node['server']['user']
  group node['server']['group']
end

execute 'untar' do
  cwd '/opt/tomcat'
  command 'sudo tar xvf apache-tomcat-8*tar.gz -C /opt/tomcat --strip-components=1'
  action :nothing
end

# The link changes very KerberosGetAFSToken
# How could I get the latest ?
remote_file 'Tomcat Binaries' do
  source 'http://www-eu.apache.org/dist/tomcat/tomcat-8/v8.5.29/bin/apache-tomcat-8.5.29.tar.gz'
  path '/opt/tomcat/apache-tomcat-8.5.28.tar.gz'
  not_if { ::File.exist?('/opt/tomcat/apache-tomcat-8.5.28.tar.gz') }
  notifies :run, 'execute[untar]', :immediately
end

directory '/opt/tomcat/conf' do
  owner node['server']['user']
  group node['server']['group']
  mode '0770'
end

# I don't know if this recursive chown can be done with Chef resources
#execute 'Recursive Chgrp' do
#  command "sudo chgrp -R tomcat /opt/tomcat/"
#end

# I don't know how to apply a single command to all the files in the same directory
execute 'Config Files Chown' do
  command "sudo chmod g+r /opt/tomcat/conf/*"
end

# I don't know if this recursive chown can be done with Chef resources
# %w( /opt/tomcat/webapps/ /opt/tomcat/work/ /opt/tomcat/temp/ /opt/tomcat/logs/).each do |dir|
execute 'Recursive Chown' do
  command "sudo chown -R #{node['server']['user']}:#{node['server']['group']} /opt/tomcat"
end
# end

template 'tomcat.service.erb' do
  source 'tomcat.service.erb'
  path '/etc/systemd/system/tomcat.service'
end

execute 'daemon-reload' do
  command 'systemctl daemon-reload'
end

service 'tomcat' do
  action [ :enable, :start ]
end

template 'server.xml.erb' do
  source 'server.xml.erb'
  mode '0750'
  owner node['server']['user']
  group node['server']['group']
  path '/opt/tomcat/conf/server.xml'
  variables(tomcatPort: node['server']['tomcat-port'])
  notifies :restart, 'service[tomcat]', :immediately
end
