require 'spec_helper'

RSpec.describe 'alfresco-appserver::tomcat_single' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(
      platform: 'centos',
      version: '7.2.1511',
      file_cache_path: '/var/chef/cache'
    ) do |node|
    end.converge(described_recipe)
  end

  before do
  end

  it 'logs Tomcat single Instance settings' do
    expect(chef_run).to write_log('Tomcat single Instance settings')
  end

  it 'runs apache_tomcat' do
    chef_run.node.normal['appserver']['alfresco']['home'] = '/usr/share/tomcat'
    chef_run.converge(described_recipe)
    expect(chef_run).to install_apache_tomcat('tomcat')
  end
end
