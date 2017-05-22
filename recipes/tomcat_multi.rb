log 'Tomcat multi Instance settings'
alfresco_home = node['appserver']['alfresco']['home']
alfresco_components = node['appserver']['alfresco']['components']
context_template_cookbook = node['tomcat']['context_template_cookbook']
context_template_source = node['tomcat']['context_template_source']

if alfresco_components.include?('repo')
  node.default['tomcat']['instances']['alfresco'] = node['tomcat']['repo_tomcat_instance']
end
if alfresco_components.include?('share')
  node.default['tomcat']['instances']['share'] = node['tomcat']['share_tomcat_instance']
end
if alfresco_components.include?('solr')
  node.default['tomcat']['instances']['solr'] = node['tomcat']['solr_tomcat_instance']
end

# last folder of alfresco_home
install_name = node['appserver']['alfresco']['home'].split('/').last

apache_tomcat install_name do
  url node['tomcat']['tar']['url']
  # Note: Checksum is SHA-256, not MD5 or SHA1. Generate using `shasum -a 256 /path/to/tomcat.tar.gz`
  checksum node['tomcat']['tar']['checksum']
  version node['tomcat']['tar']['version']
  instance_root alfresco_home
  catalina_home alfresco_home
  preserve_bundle_wars false
  user node['tomcat']['user']
  group node['tomcat']['group']

  node['tomcat']['instances'].each do |instance_name, attrs|
    logs_path = attrs['logs_path'] || "#{alfresco_home}/#{instance_name}/logs"
    cache_path = attrs['cache_path'] || "#{alfresco_home}/#{instance_name}/temp"

    umask = attrs['umask']
    setenv_options = ["export JAVA_OPTS=\"#{attrs['java_options'].map { |_k, v| v }.join(' ')}\""]
    setenv_options.push("umask #{umask}") unless umask.to_s.empty?

    apache_tomcat_instance instance_name do
      setenv_options do
        config(setenv_options)
      end
      apache_tomcat_config 'server' do
        source node['tomcat']['server_template_source']
        cookbook node['tomcat']['server_template_cookbook']
        options do
          port attrs['port']
          ssl_port attrs['ssl_port']
          ssl_proxy_port attrs['ssl_proxy_port']
          proxy_port attrs['proxy_port']
          ajp_port attrs['ajp_port']
          shutdown_port attrs['shutdown_port']
          max_threads attrs['max_threads']
          tomcat_auth attrs['tomcat_auth']
        end
      end

      template "/etc/cron.d/#{instance_name}-cleaner.cron" do
        source 'tomcat/cleaner.cron.erb'
        owner 'root'
        group 'root'
        mode 00755
        variables(tomcat_log_path: logs_path,
                  tomcat_cache_path: cache_path)
      end

      apache_tomcat_config 'context' do
        source context_template_source
        cookbook context_template_cookbook
      end

      %w(catalina.properties catalina.policy logging.properties tomcat-users.xml).each do |linked_file|
        link "linking #{linked_file}" do
          target_file "#{alfresco_home}/#{instance_name}/conf/#{linked_file}"
          to "#{alfresco_home}/conf/#{linked_file}"
          owner node['tomcat']['user']
          group node['tomcat']['group']
          mode 00755
        end
      end

      directory attrs['endorsed_dir'] do
        owner node['tomcat']['user']
        group node['tomcat']['group']
        mode 00755
        action :create
      end
    end

    template 'Creating logging.properties file' do
      path "#{alfresco_home}/conf/logging.properties"
      source 'tomcat/logging.properties.erb'
      owner node['tomcat']['user']
      group node['tomcat']['group']
      mode 00644
    end
  end
end
