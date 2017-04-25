require 'spec_helper'

RSpec.describe 'alfresco-appserver::tomcat' do
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

  it 'should include alfresco-utils::package-repositories recipe' do
    expect(chef_run).to include_recipe('alfresco-utils::package-repositories')
  end

  it 'should include alfresco-utils::java recipe' do
    chef_run.node.normal['appserver']['install_java'] = true
    chef_run.converge(described_recipe)
    expect(chef_run).to include_recipe('alfresco-utils::java')
  end

  it 'should install additional_tomcat_packages' do
    chef_run.node.normal['tomcat']['additional_tomcat_packages'] = %w(tomcat-native apr)
    chef_run.converge(described_recipe)
    expect(chef_run).to install_package('tomcat-native')
    expect(chef_run).to install_package('apr')
  end

  it 'creates a ruby_block with an explicit action' do
    expect(chef_run).to run_ruby_block('Setting jxm remote attributes for Tomcat')
  end

  it 'creates a craate /etc/cron.d directory' do
    expect(chef_run).to create_directory('/etc/cron.d')
  end

  it 'should include alfresco-appserver::tomcat_single recipe if run_single_instance is true' do
    chef_run.node.normal['tomcat']['run_single_instance'] = true
    chef_run.converge(described_recipe)
    expect(chef_run).to include_recipe('alfresco-appserver::tomcat_single')
  end

  it 'should include alfresco-appserver::tomcat_multi recipe if run_single_instance is false' do
    chef_run.node.normal['tomcat']['run_single_instance'] = false
    chef_run.converge(described_recipe)
    expect(chef_run).to include_recipe('alfresco-appserver::tomcat_multi')
  end

  it 'should create directories and templates if global_templates is set' do
    chef_run.node.normal['tomcat']['global_templates'] = [{
      'dest' => 'dest1',
      'filename' => 'filename1',
      'owner' => 'owner1',
    }, {
      'dest' => 'dest2',
      'filename' => 'filename2',
      'owner' => 'owner2',
    }]
    chef_run.converge(described_recipe)
    expect(chef_run).to create_directory('dest1')
    expect(chef_run).to create_directory('dest2')
    expect(chef_run).to create_template('dest1/filename1').with(owner: 'owner1', group: 'owner1')
    expect(chef_run).to create_template('dest2/filename2').with(owner: 'owner2', group: 'owner2')
  end

  it 'should run Replace ServerInfo inside catalina.jar' do
    chef_run.node.normal['appserver']['alfresco']['home'] = '/usr/share/tomcat'
    allow(File).to receive(:exist?)
      .and_call_original
    allow(File).to receive(:exist?)
      .with('/usr/share/tomcat/lib/catalina.jar')
      .and_return(true)
    chef_run.converge(described_recipe)
    expect(chef_run).to run_execute('Replace ServerInfo inside catalina.jar')
  end

  it 'setup maven' do
    chef_run.node.normal['appserver']['install_maven'] = true
    chef_run.converge(described_recipe)
    expect(chef_run).to create_maven_setup('setup maven')
  end

  it 'deploy artifacts' do
    chef_run.node.normal['appserver']['download_artifacts'] = true
    chef_run.converge(described_recipe)
    expect(chef_run).to create_artifact('deploy artifacts')
  end
end
