run_single_instance = node['tomcat']['run_single_instance']

# needed to install `additional_tomcat_packages`
include_recipe 'alfresco-utils::package-repositories'

include_recipe 'alfresco-utils::java' if node['appserver']['install_java']

node.default['artifacts']['catalina-jmx']['enabled'] = true

additional_tomcat_packages = node['tomcat']['additional_tomcat_packages']
additional_tomcat_packages.each do |pkg|
  package pkg do
    action :install
  end
end

jmxremote_databag = node['appserver']['alfresco']['jmxremote_databag']
jmxremote_databag_items = node['appserver']['alfresco']['jmxremote_databag_items']

ruby_block 'Setting jxm remote attributes for Tomcat' do
  block do
    begin
      jmxremote_databag_items.each do |jmxremote_databag_item|
        db_item = data_bag_item(jmxremote_databag, jmxremote_databag_item)
        node.default['tomcat']["jmxremote_#{jmxremote_databag_item}_role"] = db_item['username']
        node.default['tomcat']["jmxremote_#{jmxremote_databag_item}_password"] = db_item['password']
        node.default['tomcat']["jmxremote_#{jmxremote_databag_item}_access"] = db_item['access']
      end
    rescue
      Chef::Log.warn("Error fetching databag #{jmxremote_databag},  item #{jmxremote_databag_items}")
    end
  end
  action :run
end

directory '/etc/cron.d' do
  action :create
end

if run_single_instance
  include_recipe 'alfresco-appserver::tomcat_single'
else
  include_recipe 'alfresco-appserver::tomcat_multi'
end

global_templates = node['tomcat']['global_templates']
unless global_templates.to_a.empty?
  global_templates.each do |global_template|
    directory global_template['dest'] do
      action :create
      recursive true
    end

    log "global_template['dest'] --> #{global_template['dest']}"

    template "#{global_template['dest']}/#{global_template['filename']}" do
      path "#{global_template['dest']}/#{global_template['filename']}"
      source "tomcat/#{global_template['filename']}.erb"
      owner global_template['owner']
      group global_template['owner']
      only_if { [true, false].include?(global_template['onlyIf']) ? global_template['onlyIf'] : true }
      mode 00700
    end
  end
end

# ref: https://www.owasp.org/index.php/Securing_tomcat
execute 'Replace ServerInfo inside catalina.jar' do
  command 'jar uf catalina.jar org/apache/catalina/util/ServerInfo.properties && rm -rf org'
  cwd "#{node['appserver']['alfresco']['home']}/lib"
  action :run
  only_if { ::File.exist?("#{node['appserver']['alfresco']['home']}/lib/catalina.jar") }
end

maven_setup 'setup maven' do
  maven_home node['maven']['m2_home']
  only_if { node['appserver']['install_maven'] }
  action :create
end

artifact 'deploy artifacts' if node['appserver']['download_artifacts']
