alfresco_components =  node['appserver']['alfresco']['components']
alfresco_home = node['appserver']['alfresco']['home']

# set transient alfresco_home to be used by other recipes
node.run_state['alfresco_home'] = alfresco_home

rmi_server_hostname = node['appserver']['alfresco']['rmi_server_hostname']

# needed to install `additional_tomcat_packages`
include_recipe 'alfresco-utils::package-repositories'

include_recipe 'alfresco-utils::java' if node['appserver']['install_java']

if node['tomcat']['run_single_instance']
  logs_path = "#{alfresco_home}/logs"
  node.default['tomcat']['java_options']['log_paths'] = "-Djava.util.logging.config.file=#{alfresco_home}/conf/logging.properties -Dlog4j.configuration=alfresco/log4j.properties -Xloggc:#{logs_path}/gc.log -Dlogfilename=#{logs_path}/alfresco.log -XX:ErrorFile=#{logs_path}/jvm_crash%p.log -XX:HeapDumpPath=#{logs_path}/"
  if alfresco_components.include?('solr')
    node.default['tomcat']['java_options']['rmi_and_solr'] = "-Dalfresco.home=#{alfresco_home} -Djava.rmi.server.hostname=#{rmi_server_hostname} -Dsolr.solr.home=#{node['appserver']['alfresco']['solr']['home']} -Dsolr.solr.model.dir=#{node['appserver']['alfresco']['solr']['alfresco_models']} -Dsolr.solr.content.dir=#{node['appserver']['alfresco']['solr']['contentstore.path']}"
  end
else
  if alfresco_components.include?('repo')
    name = 'repo'
    instance_home = "#{alfresco_home}/alfresco"
    logs_path = node['tomcat']["#{name}_tomcat_instance"]['logs_path'] || "#{alfresco_home}/alfresco/logs"
    node.default['tomcat']['repo_tomcat_instance']['java_options']['rmi_and_alfhome'] = "-Dalfresco.home=#{instance_home} -Djava.rmi.server.hostname=#{rmi_server_hostname}"
    node.default['tomcat']['repo_tomcat_instance']['java_options']['log_paths'] = "-Djava.util.logging.config.file=#{instance_home}/conf/logging.properties -Dlog4j.configuration=alfresco/log4j.properties -Xloggc:#{logs_path}/gc.log -Dlogfilename=#{logs_path}/alfresco.log -XX:ErrorFile=#{logs_path}/jvm_crash%p.log -XX:HeapDumpPath=#{logs_path}/"
    node.default['tomcat']['instances']['alfresco'] = node['tomcat']['repo_tomcat_instance']
  end
  if alfresco_components.include?('share')
    name = 'share'
    instance_home = "#{alfresco_home}/share"
    logs_path = node['tomcat']["#{name}_tomcat_instance"]['logs_path'] || "#{alfresco_home}/#{name}/logs"
    node.default['tomcat']['share_tomcat_instance']['java_options']['rmi'] = "-Djava.rmi.server.hostname=#{rmi_server_hostname}"
    node.default['tomcat']['share_tomcat_instance']['java_options']['log_paths'] = "-Djava.util.logging.config.file=#{instance_home}/conf/logging.properties -Dlog4j.configuration=alfresco/log4j.properties -Xloggc:#{logs_path}/gc.log -Dlogfilename=#{logs_path}/share.log -XX:ErrorFile=#{logs_path}/jvm_crash%p.log -XX:HeapDumpPath=#{logs_path}/"
    node.default['tomcat']['instances']['share'] = node['tomcat']['share_tomcat_instance']
  end
  if alfresco_components.include?('solr')
    name = 'solr'
    instance_home = "#{alfresco_home}/solr"
    logs_path = node['tomcat']["#{name}_tomcat_instance"]['logs_path'] || "#{alfresco_home}/#{name}/logs"
    node.default['tomcat']['solr_tomcat_instance']['java_options']['rmi_and_solr'] = "-Djava.rmi.server.hostname=#{rmi_server_hostname} -Dsolr.solr.model.dir=#{node['appserver']['alfresco']['solr']['alfresco_models']} -Dsolr.solr.home=#{node['appserver']['alfresco']['solr']['home']}  -Dsolr.solr.content.dir=#{node['appserver']['alfresco']['solr']['contentstore.path']}"
    node.default['tomcat']['solr_tomcat_instance']['java_options']['log_paths'] = "-Djava.util.logging.config.file=#{instance_home}/conf/logging.properties -Dlog4j.configuration=alfresco/log4j.properties -Xloggc:#{instance_home}/gc.log -Dlogfilename=#{logs_path}/solr.log -XX:ErrorFile=#{logs_path}/jvm_crash%p.log -XX:HeapDumpPath=#{logs_path}/"
    node.default['tomcat']['instances']['solr'] = node['tomcat']['solr_tomcat_instance']
  end
end

node.default['artifacts']['alfresco-mmt']['enabled'] = true
node.default['artifacts']['sharedclasses']['enabled'] = true
node.default['artifacts']['catalina-jmx']['enabled'] = true

context_template_cookbook = node['tomcat']['context_template_cookbook']
context_template_source = node['tomcat']['context_template_source']

additional_tomcat_packages = node['tomcat']['additional_tomcat_packages']
additional_tomcat_packages.each do |pkg|
  package pkg do
    action :install
  end
end

jmxremote_databag = node['appserver']['alfresco']['jmxremote_databag']
jmxremote_databag_items = node['appserver']['alfresco']['jmxremote_databag_items']

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

directory '/etc/cron.d' do
  action :create
end

install_name = if node['tomcat']['run_single_instance']
                 'tomcat-single'
               else
                 'tomcat-multi'
               end

apache_tomcat install_name do
  url node['tomcat']['tar']['url']
  # Note: Checksum is SHA-256, not MD5 or SHA1. Generate using `shasum -a 256 /path/to/tomcat.tar.gz`
  checksum node['tomcat']['tar']['checksum']
  version node['tomcat']['tar']['version']
  instance_root alfresco_home
  catalina_home alfresco_home
  user node['tomcat']['user']
  group node['tomcat']['group']

  if node['tomcat']['run_single_instance']
    apache_tomcat_instance node['tomcat']['single_instance'] do
      single_instance node['tomcat']['run_single_instance']
      setenv_options do
        config(
          [
            "export JAVA_OPTS=\"#{node['tomcat']['java_options'].map { |_k, v| v }.join(' ')}\"",
          ]
        )
      end
      apache_tomcat_config 'server' do
        source node['tomcat']['server_template_source']
        cookbook node['tomcat']['server_template_cookbook']
        options do
          port node['tomcat']['port']
          proxy_port node['tomcat']['proxy_port']
          ssl_port node['tomcat']['ssl_port']
          ssl_proxy_port node['tomcat']['ssl_proxy_port']
          ajp_port node['tomcat']['ajp_port']
          shutdown_port node['tomcat']['shutdown_port']
        end
      end

      template "/etc/cron.d/#{node['tomcat']['single_instance']}-cleaner.cron" do
        source 'tomcat/cleaner.cron.erb'
        owner 'root'
        group 'root'
        mode '0755'
        variables(tomcat_log_path: "#{alfresco_home}/logs",
                  tomcat_cache_path: "#{alfresco_home}/temp")
      end

      # %W(catalina.properties catalina.policy logging.properties tomcat-users.xml).each do |linked_file|
      #   link "linking #{linked_file}" do
      #     target_file "#{alfresco_home}/conf/#{linked_file}"
      #     to "#{alfresco_home}/conf/#{linked_file}"
      #   end
      # end

      apache_tomcat_config 'context' do
        source node['tomcat']['context_template_source']
        cookbook node['tomcat']['context_template_cookbook']
      end
    end

  else

    node['tomcat']['instances'].each do |name, attrs|
      logs_path = attrs['logs_path'] || "#{alfresco_home}/#{name}/logs"
      cache_path = attrs['cache_path'] || "#{alfresco_home}/#{name}/temp"

      apache_tomcat_instance name do
        setenv_options do
          config(
            [
              "export JAVA_OPTS=\"#{attrs['java_options'].map { |_k, v| v }.join(' ')}\"",
            ]
          )
        end
        apache_tomcat_config 'server' do
          source node['tomcat']['server_template_source']
          cookbook node['tomcat']['server_template_cookbook']
          options do
            port attrs['port']
            proxy_port attrs['proxy_port']
            ajp_port attrs['ajp_port']
            shutdown_port attrs['shutdown_port']
            max_threads attrs['max_threads']
            tomcat_auth attrs['tomcat_auth']
          end
        end

        template "/etc/cron.d/#{name}-cleaner.cron" do
          source 'tomcat/cleaner.cron.erb'
          owner 'root'
          group 'root'
          mode '0755'
          variables(tomcat_log_path: logs_path,
                    tomcat_cache_path: cache_path)
        end

        apache_tomcat_config 'context' do
          source context_template_source
          cookbook context_template_cookbook
        end

        %w(catalina.properties catalina.policy logging.properties tomcat-users.xml).each do |linked_file|
          link "linking #{linked_file}" do
            target_file "#{alfresco_home}/#{name}/conf/#{linked_file}"
            to "#{alfresco_home}/conf/#{linked_file}"
            owner node['tomcat']['user']
            group node['tomcat']['group']
            mode '0755'
          end
        end

        directory attrs['endorsed_dir'] do
          owner node['tomcat']['user']
          group node['tomcat']['group']
          mode '0755'
          action :create
        end

      end

      template 'Creating logging.properties file' do
        path "#{alfresco_home}/conf/logging.properties"
        source 'tomcat/logging.properties.erb'
        owner 'root'
        group 'root'
        mode '0644'
      end
    end
  end
end

maven_setup 'setup maven' do
  maven_home node['maven']['m2_home']
  only_if { node['appserver']['install_maven'] }
end

artifact 'deploy artifacts' if node['appserver']['download_artifacts']
