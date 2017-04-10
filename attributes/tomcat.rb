default['tomcat']['tar']['url'] = 'http://archive.apache.org/dist/tomcat/tomcat-7/v7.0.59/bin/apache-tomcat-7.0.59.tar.gz'
# Note: Checksum is SHA-256, not MD5 or SHA1. Generate using `shasum -a 256 /path/to/tomcat.tar.gz`
default['tomcat']['tar']['checksum'] = 'e0fe43d1fa17013bf7b3b2d3f71105d606a0582c153eb16fb210e7d5164941b0'
default['tomcat']['tar']['version'] = '7.0.59'

# Tomcat attributes for base instance
default['tomcat']['port'] = 8080
default['tomcat']['proxy_port'] = nil
default['tomcat']['ssl_port'] = 8443
default['tomcat']['ssl_proxy_port'] = nil
default['tomcat']['ssl_enabled'] = node['appserver']['ssl_enabled']
default['tomcat']['ssl_max_threads'] = 150

default['tomcat']['ajp_port'] = 8009
default['tomcat']['jmx_port'] = nil
default['tomcat']['shutdown_port'] = 8005
default['tomcat']['open_files_limit'] = 16000
default['tomcat']['processes_limit'] = 65000

memory_total = node['memory']['total']

default['tomcat']['java_options']['memory'] = "-Xmx#{(memory_total.to_i * 0.6).floor / 1024}m -Djava.awt.headless=true"
default['tomcat']['max_threads'] = nil

default['tomcat']['loglevel'] = 'INFO'
default['tomcat']['instances'] = {}
default['tomcat']['maxHttpHeaderSize'] = '1048576'
default['tomcat']['cleaner.minutes.interval'] = 30
default['tomcat']['cache_root_folder'] = '/var/cache'
default['tomcat']['memcached_nodes'] = ''
default['tomcat']['additional_tomcat_packages'] = %w(tomcat-native apr)

# Use multi-homed tomcat installation
default['tomcat']['run_single_instance'] = false

# Context.xml settings
default['tomcat']['swallow_output'] = true
default['tomcat']['use_http_only'] = true

default['tomcat']['server_template_cookbook'] = 'alfresco-appserver'
default['tomcat']['server_template_source'] = 'tomcat/server.xml.erb'
default['tomcat']['context_template_cookbook'] = 'alfresco-appserver'
default['tomcat']['context_template_source'] = 'tomcat/context.xml.erb'

default['tomcat']['java_options_hash']['generic_memory'] = '-XX:+UseCompressedOops'
default['tomcat']['java_options_hash']['gc'] = '-XX:+DisableExplicitGC  -XX:+PrintGCDetails -XX:+PrintGCTimeStamps -verbose:gc'
default['tomcat']['java_options_hash']['network'] = '-Djava.net.preferIPv4Stack=true -Djava.net.preferIPv4Addresses=true -Dsun.net.inetaddr.ttl=0 -Dsun.net.inetaddr.negative.ttl=0 -Dsun.security.ssl.allowUnsafeRenegotiation=true'
default['tomcat']['java_options_hash']['logging'] = ' -Dhazelcast.logging.type=log4j'
default['tomcat']['java_options_hash']['others'] = '-Djava.library.path=/usr/lib64 -Djava.awt.headless=true'

default['tomcat']['repo_tomcat_instance']['port'] = 8070
default['tomcat']['repo_tomcat_instance']['shutdown_port'] = 8005
default['tomcat']['repo_tomcat_instance']['jmx_port'] = 40000
default['tomcat']['repo_tomcat_instance']['xmx_ratio'] = 0.42
alfresco_memory = "#{(memory_total.to_i * node['tomcat']['repo_tomcat_instance']['xmx_ratio']).floor / 1024}m"
default['tomcat']['repo_tomcat_instance']['java_options']['xmx_memory'] = "-Xmx#{alfresco_memory}"

default['tomcat']['share_tomcat_instance']['port'] = 8081
default['tomcat']['share_tomcat_instance']['shutdown_port'] = 8015
default['tomcat']['share_tomcat_instance']['jmx_port'] = 40010
default['tomcat']['share_tomcat_instance']['xmx_ratio'] = 0.28
share_memory = "#{(memory_total.to_i * node['tomcat']['share_tomcat_instance']['xmx_ratio']).floor / 1024}m"
default['tomcat']['share_tomcat_instance']['java_options']['xmx_memory'] = "-Xmx#{share_memory}"

default['tomcat']['solr_tomcat_instance']['port'] = 8090
default['tomcat']['solr_tomcat_instance']['shutdown_port'] = 8025
default['tomcat']['solr_tomcat_instance']['jmx_port'] = 40020
default['tomcat']['solr_tomcat_instance']['xmx_ratio'] = 0.3
solr_memory = "#{(memory_total.to_i * node['tomcat']['solr_tomcat_instance']['xmx_ratio']).floor / 1024}m"
default['tomcat']['solr_tomcat_instance']['java_options']['xmx_memory'] = "-Xmx#{solr_memory}"

##############

default['tomcat']['base_version'] = 7
default['tomcat']['single_instance'] = 'alfresco'
default['tomcat']['user'] = 'tomcat'
default['tomcat']['group'] = 'tomcat'
# default['tomcat']['tomcat_single_path'] = '/usr/share/tomcat-single'
# default['tomcat']['tomcat_multi_path'] = '/usr/share/tomcat-multi'
#
# default['appserver']['alfresco']['home'] = if node['tomcat']['run_single_instance']
#                                              node['tomcat']['tomcat_single_path']
#                                            else
#                                              node['tomcat']['tomcat_multi_path']
#                                            end

default['tomcat']['jmxremote_path'] = lazy { "#{node['appserver']['alfresco']['home']}/conf" }
default['tomcat']['jmxremote_access_filename'] = 'jmxremote.access'
default['tomcat']['jmxremote_password_filename'] = 'jmxremote.password'
jmxremote_access_fullpath = lazy { "#{node['tomcat']['jmxremote_path']}/#{node['tomcat']['jmxremote_access_filename']}" }
jmxremote_password_fullpath = lazy { "#{node['tomcat']['jmxremote_path']}/#{node['tomcat']['jmxremote_password_filename']}" }

default['artifacts']['catalina-jmx']['destination'] = lazy '%{appserver.alfresco.home}/lib'
default['artifacts']['memcached-session-manager']['destination'] = lazy '%{appserver.alfresco.home}/lib'
default['artifacts']['memcached-session-manager-tc7']['destination'] = lazy '%{appserver.alfresco.home}/lib'
default['artifacts']['spymemcached']['destination'] = lazy '%{appserver.alfresco.home}/lib'
default['artifacts']['msm-kryo-serializer']['destination'] = lazy '%{appserver.alfresco.home}/lib'
default['artifacts']['kryo-serializers']['destination'] = lazy '%{appserver.alfresco.home}/lib'
default['artifacts']['kryo']['destination'] = lazy '%{appserver.alfresco.home}/lib'
default['artifacts']['minlog']['destination'] = lazy '%{appserver.alfresco.home}/lib'
default['artifacts']['reflectasm']['destination'] = lazy '%{appserver.alfresco.home}/lib'
default['artifacts']['asm']['destination'] = lazy '%{appserver.alfresco.home}/lib'
default['artifacts']['objenesis']['destination'] = lazy '%{appserver.alfresco.home}/lib'

# attributes for share.xml.erb
default['tomcat']['memcached']['sticky'] = true
default['tomcat']['memcached']['sessionBackupAsync'] = true
default['tomcat']['memcached']['copyCollectionsForSerialization'] = false

default['tomcat']['jvm_route'] = node['appserver']['alfresco']['public_hostname']

# Setting JAVA_OPTS
default['tomcat']['java_options_hash']['jmx'] = lazy { "-Dcom.sun.management.jmxremote=true  -Dcom.sun.management.jmxremote.authenticate=true -Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.ssl=false -Dcom.sun.management.jmxremote.access.file=#{jmxremote_access_fullpath} -Dcom.sun.management.jmxremote.password.file=#{jmxremote_password_fullpath}" }

default['tomcat']['repo_tomcat_instance']['java_options'] = node['tomcat']['java_options_hash']
default['tomcat']['share_tomcat_instance']['java_options'] = node['tomcat']['java_options_hash']
default['tomcat']['solr_tomcat_instance']['java_options'] = node['tomcat']['java_options_hash']

default['tomcat']['global_templates'] = [{
  'dest' => node['tomcat']['jmxremote_path'],
  'filename' => node['tomcat']['jmxremote_access_filename'],
  'owner' => node['appserver']['alfresco']['user'],
}, {
  'dest' => node['tomcat']['jmxremote_path'],
  'filename' => node['tomcat']['jmxremote_password_filename'],
  'owner' => node['appserver']['alfresco']['user'],
}, {
  'dest' => "#{node['appserver']['alfresco']['home']}/lib/org/apache/catalina/util",
  'filename' => 'ServerInfo.properties',
  'owner' => node['appserver']['alfresco']['user'],
}, {
  'dest' => '/etc/security/limits.d',
  'filename' => 'tomcat_limits.conf',
  'owner' => node['appserver']['alfresco']['user'],
}, {
  'dest' => "#{node['appserver']['alfresco']['home']}/share/conf/Catalina/localhost",
  'filename' => 'share.xml',
  'owner' => node['appserver']['alfresco']['user'],
  'onlyIf' => !node['tomcat']['memcached_nodes'].empty? && node['appserver']['alfresco']['components'].include?('share'),
}]
