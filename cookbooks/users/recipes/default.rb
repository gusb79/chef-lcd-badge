# Cookbook:: users
# Recipe:: default
#
# Copyright:: 2018, The Authors, All Rights Reserved.


current_time = Time.now
if (current_time.hour >= 9) and (current_time.hour <= 17)
  ::File.new('/tmp/usersallowed', 'w+')
else
  ::File.delete('/tmp/usersallowed')
end

# Alternatively:
# search("groups", "*:*") do |group|
data_bag('groups').map do |group|
  group data_bag_item('groups', group)['id'] do
    gid data_bag_item('groups', group)['gid']
    members data_bag_item('groups', group)['members']

    if ::File.exist?('/tmp/usersallowed')
      action :create
    else
      action :delete
    end

  end
end


# Alternatively:
# search("users", "*:*") do |user|
data_bag('users').map do |user|
  user data_bag_item('users', user)['id'] do
    comment data_bag_item('users', user)['comment']
    uid data_bag_item('users', user)['uid']
    gid data_bag_item('users', user)['gid']
    home data_bag_item('users', user)['home']
    shell data_bag_item('users', user)['shell']

    if ::File.exist?('/tmp/usersallowed')
      action :create
    else
      action :delete
    end

    notifies :create, 'file[timestamp]'

  end
end


file 'timestamp' do
  currentTime lazy { Time::now }
  content currentTime
  path '/tmp/timestamp'
  action :nothing
end


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
