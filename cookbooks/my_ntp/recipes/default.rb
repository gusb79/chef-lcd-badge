#
# Cookbook:: my_ntp
# Recipe:: default
#
# Copyright:: 2018, The Authors, All Rights Reserved.
include_recipe 'ntp'

file '/etc/ntp.conf' do
  content 'server 0.rhel.pool.ntp.org
server 1.rhel.pool.ntp.org
server 2.rhel.pool.ntp.org'
end
