# encoding: utf-8

# Inspec test for recipe tomcat::server

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

describe package('java-1.7.0-openjdk-devel') do
  it { should be_installed }
end

describe user('tomcat') do
  it { should exist }
end

describe group('tomcat') do
  it { should exist }
end

describe directory('/opt/tomcat/conf') do
  it { should exist }
  its('mode') { should cmp '0770' }
end

describe file('/etc/systemd/system/tomcat.service') do
  it { should exist }
  its(:content) { should match /CATALINA/ }
end

describe service('tomcat') do
  it {  should be_enabled }
  it {  should be_running }
end

describe port('8080') do
  it { should be_listening }
end

describe command('curl http://localhost:8080/') do
  its(:stdout) { should match(/Tomcat/) }
end
