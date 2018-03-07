#
# Cookbook:: tomcat
# Recipe:: server
#
# Copyright:: 2018, The Authors, All Rights Reserved.
node['server']['user'] = 'tomcat'
node['server']['group'] = 'tomcat'

package 'java-1.7.0-openjdk-devel'

group node['server']['group']

user node['server']['user'] do
  group node['server']['group']
end

directory '/opt/tomcat' do
  owner node['server']['user']
  group node['server']['group']
end

remote_file 'Tomcat Binaries' do
  source 'http://mirror.ox.ac.uk/sites/rsync.apache.org/tomcat/tomcat-8/v8.5.28/bin/apache-tomcat-8.5.28.tar.gz'
  path '/opt/tomcat'
  not_if { ::File.exist?('/opt/tomcat/conf') }
  notifies :run, execute['untar']
end

execute 'untar' do
  cwd '/opt/tomcat'
  command 'sudo tar xvf apache-tomcat-8*tar.gz -C /opt/tomcat --strip-components=1'
  action :nothing
end


directory '/opt/tomcat/conf' do
  owner node['server']['user']
  group node['server']['group']
  mode '0770'
end

# I don't know if this recursive chown can be done with Chef resources
execute 'Recursive Chgrp' do
  command "sudo chgrp -R tomcat /opt/tomcat/conf/"
end

# I don't know how to apply a single command to all the files in the same directory
execute 'Config Files Chown' do
  command "sudo chmod g+r /opt/tomcat/conf/*"
end

# I don't know if this recursive chown can be done with Chef resources
%w( /opt/tomcat/webapps/ /opt/tomcat/work/ /opt/tomcat/temp/ /opt/tomcat/logs/).each do |dir|
execute 'Recursive Chown' do
  command "sudo chown -R #{node['server']['user']} #{dir}"
end


template 'tomcat.service' do
  source 'tomcat.service.erb'
  path '/etc/systemd/system/tomcat.service'
  action [:create_if_missing]
  notifies :run, 'execute[daemon-reload]', :immediately
end

execute 'daemon-reload' do
  command 'sudo systemctl daemon-reload'
  action :nothing
end

service 'tomcat' do
  action [ :enable, :start ]
end

template 'server.xml' do
  source 'service.xml.erb'
  mode '0750'
  owner node['server']['user']
  group node['server']['group']
  path '/opt/tomcat/conf/server.xml'
  variables ( tomcatPort: node['server']['tomcat-port'])
  notifies :reload, 'service[tomcat]', :immediately
end
