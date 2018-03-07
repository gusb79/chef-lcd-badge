#
# Cookbook:: tomcat
# Spec:: default
#
# Copyright:: 2018, The Authors, All Rights Reserved.

require 'spec_helper'

describe 'tomcat::server' do

  context 'When all attributes are default, on CentOS 7.4.1708' do
    let(:chef_run) do
      # for a complete list of available platforms and versions see:
      # https://github.com/customink/fauxhai/blob/master/PLATFORMS.md
      runner = ChefSpec::ServerRunner.new(platform: 'centos', version: '7.4.1708')
      runner.converge(described_recipe)
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end

    it 'installs required packages' do
      expect { chef_run }.to install_package('java-1.7.0-openjdk-devel')
    end

    it 'creates the tomcat user and group' do
      expect { chef_run }.to create_group('tomcat')
      expect { chef_run }.to create_user('tomcat').with( group: 'tomcat')
    end

    it 'creates the directory' do
      expect { chef_run }.to create_directory('/opt/tomcat').with( owner: 'tomcat', group: 'tomcat', mode: '750')
    end


    # Difficult to test the recursive requirements of this installation like chgrp -R, etc
    it 'modifies the directory' do
      expect { chef_run }.to create_directory('/opt/tomcat/conf').with( group: 'tomcat' )
      expect { chef_run }.to create_directory('/opt/tomcat/conf').with( mode: '740')
    end

  end
end
