# # encoding: utf-8

# Inspec test for recipe users::default

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

describe user('chef') do
  it { should exist }
  # Requires a ruby gem in order to work
  # its('password') { should eq 'chef' }
end

describe file('/etc/ssh/sshd_config') do
  it { should exist }
end

describe sshd_config do
  its('PasswordAuthentication') { should eq 'yes' }
end

describe service('sshd') do
  it { should be_enabled }
  it { should be_running }
end
