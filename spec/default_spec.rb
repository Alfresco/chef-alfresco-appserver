require 'spec_helper'

RSpec.describe 'alfresco-appserver::default' do
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

  it 'should include tomcat as default recipe' do
    chef_run.node.normal['appserver']['engine'] = 'tomcat'
    chef_run.converge(described_recipe)
    expect(chef_run).to include_recipe('alfresco-appserver::tomcat')
  end

end
