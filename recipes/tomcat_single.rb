log 'Tomcat single Instance settings'
alfresco_home = node['appserver']['alfresco']['home']
alfresco_components = node['appserver']['alfresco']['components']
rmi_server_hostname = node['appserver']['alfresco']['rmi_server_hostname']
context_template_source = node['tomcat']['context_template_source']
context_template_cookbook = node['tomcat']['context_template_cookbook']

if alfresco_components.include?('solr')
  node.default['tomcat']['java_options']['rmi_and_solr'] = "-Dalfresco.home=#{alfresco_home} -Djava.rmi.server.hostname=#{rmi_server_hostname} -Dsolr.solr.home=#{node['appserver']['alfresco']['solr']['home']} -Dsolr.solr.model.dir=#{node['appserver']['alfresco']['solr']['alfresco_models']} -Dsolr.solr.content.dir=#{node['appserver']['alfresco']['solr']['contentstore.path']}"
end

# last folder of alfresco_home
install_name = node['appserver']['alfresco']['home'].split('/').last

umask = node['tomcat']['umask']
setenv_options = ["export JAVA_OPTS=\"#{node['tomcat']['java_options'].map { |_k, v| v }.join(' ')}\""]
setenv_options.push("umask #{umask}") unless umask.to_s.empty?

apache_tomcat install_name do
  url node['tomcat']['tar']['url']
  # Note: Checksum is SHA-256, not MD5 or SHA1. Generate using `shasum -a 256 /path/to/tomcat.tar.gz`
  checksum node['tomcat']['tar']['checksum']
  version node['tomcat']['tar']['version']
  instance_root alfresco_home
  catalina_home alfresco_home
  user node['tomcat']['user']
  group node['tomcat']['group']
  preserve_bundle_wars false

  apache_tomcat_instance node['tomcat']['single_instance'] do
    single_instance true
    setenv_options do
      config(setenv_options)
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
      mode 00755
      variables(tomcat_log_path: "#{alfresco_home}/logs",
                tomcat_cache_path: "#{alfresco_home}/temp")
    end

    apache_tomcat_config 'context' do
      source context_template_source
      cookbook context_template_cookbook
    end
  end
end
