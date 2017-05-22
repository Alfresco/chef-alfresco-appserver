default['tomcat']['tar']['url'] = 'http://archive.apache.org/dist/tomcat/tomcat-7/v7.0.59/bin/apache-tomcat-7.0.59.tar.gz'
# Note: Checksum is SHA-256, not MD5 or SHA1. Generate using `shasum -a 256 /path/to/tomcat.tar.gz`
default['tomcat']['tar']['checksum'] = 'e0fe43d1fa17013bf7b3b2d3f71105d606a0582c153eb16fb210e7d5164941b0'
default['tomcat']['tar']['version'] = '7.0.59'

# Tomcat attributes for base instance
default['tomcat']['port'] = node['appserver']['port']
default['tomcat']['proxy_port'] = nil
default['tomcat']['ssl_port'] = 8443
default['tomcat']['ssl_proxy_port'] = nil
default['tomcat']['ssl_enabled'] = node['appserver']['ssl_enabled']
default['tomcat']['ssl_max_threads'] = 150
default['tomcat']['server'] = 'Alfresco Server'

default['tomcat']['ajp_port'] = 8009
default['tomcat']['jmx_port'] = nil
default['tomcat']['shutdown'] = 'CHANGEME'
default['tomcat']['shutdown_port'] = -1
default['tomcat']['open_files_limit'] = 16000
default['tomcat']['processes_limit'] = 65000

memory_total = node['memory']['total']

# single tomcat settings
default['tomcat']['java_options']['memory'] = "-Xmx#{(memory_total.to_i * 0.6).floor / 1024}m -Djava.awt.headless=true"
# default['tomcat']['java_options']['servlet_compliance'] = '-Dorg.apache.catalina.STRICT_SERVLET_COMPLIANCE=true'
default['tomcat']['java_options']['recycle_facades'] = '-Dorg.apache.catalina.connector.RECYCLE_FACADES=true'
# default['tomcat']['java_options']['path_delimiters'] = '-Dorg.apache.catalina.connector.CoyoteAdapter.ALLOW_BACKSLASH=false -Dorg.apache.tomcat.util.buf.UDecoder.ALLOW_ENCODED_SLASH=false'
default['tomcat']['java_options']['custmom_header_status_message'] = '-Dorg.apache.coyote.USE_CUSTOM_STATUS_MSG_IN_HEADER=false'
default['tomcat']['java_options']['log_paths'] = lazy { "-Djava.util.logging.config.file=#{node['appserver']['alfresco']['home']}/conf/logging.properties -Xloggc:#{node['appserver']['alfresco']['home']}/logs/gc.log -XX:ErrorFile=#{node['appserver']['alfresco']['home']}/logs/jvm_crash%p.log -XX:HeapDumpPath=#{node['appserver']['alfresco']['home']}/logs/" }

default['tomcat']['max_threads'] = nil

default['tomcat']['client_auth'] = true
default['tomcat']['loglevel'] = 'INFO'
default['tomcat']['instances'] = {}
default['tomcat']['maxHttpHeaderSize'] = '8192'
default['tomcat']['cleaner.minutes.interval'] = 30
default['tomcat']['cache_root_folder'] = '/var/cache'
default['tomcat']['memcached_nodes'] = ''
default['tomcat']['additional_tomcat_packages'] = %w(tomcat-native apr)

# Use multi-homed tomcat installation
default['tomcat']['run_single_instance'] = node['appserver']['run_single_instance']

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
# default['tomcat']['java_options_hash']['servlet_compliance'] = '-Dorg.apache.catalina.STRICT_SERVLET_COMPLIANCE=true'
default['tomcat']['java_options_hash']['recycle_facades'] = '-Dorg.apache.catalina.connector.RECYCLE_FACADES=true'
# default['tomcat']['java_options_hash']['path_delimiters'] = '-Dorg.apache.catalina.connector.CoyoteAdapter.ALLOW_BACKSLASH=false -Dorg.apache.tomcat.util.buf.UDecoder.ALLOW_ENCODED_SLASH=false'
default['tomcat']['java_options_hash']['custmom_header_status_message'] = '-Dorg.apache.coyote.USE_CUSTOM_STATUS_MSG_IN_HEADER=false'
default['tomcat']['java_options_hash']['others'] = '-Djava.library.path=/usr/lib64 -Djava.awt.headless=true'
default['tomcat']['umask'] = '002'

default['tomcat']['repo_tomcat_instance']['port'] = 8070
default['tomcat']['repo_tomcat_instance']['ssl_port'] = node['tomcat']['ssl_port']
default['tomcat']['repo_tomcat_instance']['ssl_proxy_port'] = node['tomcat']['ssl_proxy_port']
default['tomcat']['repo_tomcat_instance']['shutdown_port'] = -1
default['tomcat']['repo_tomcat_instance']['jmx_port'] = 40000
default['tomcat']['repo_tomcat_instance']['xmx_ratio'] = 0.42
alfresco_memory = "#{(memory_total.to_i * node['tomcat']['repo_tomcat_instance']['xmx_ratio']).floor / 1024}m"
default['tomcat']['repo_tomcat_instance']['java_options']['xmx_memory'] = "-Xmx#{alfresco_memory}"
default['tomcat']['repo_tomcat_instance']['umask'] = '002'

default['tomcat']['share_tomcat_instance']['port'] = 8081
default['tomcat']['share_tomcat_instance']['ssl_port'] = node['tomcat']['ssl_port']
default['tomcat']['share_tomcat_instance']['ssl_proxy_port'] = node['tomcat']['ssl_proxy_port']
default['tomcat']['share_tomcat_instance']['shutdown_port'] = -1
default['tomcat']['share_tomcat_instance']['jmx_port'] = 40010
default['tomcat']['share_tomcat_instance']['xmx_ratio'] = 0.28
share_memory = "#{(memory_total.to_i * node['tomcat']['share_tomcat_instance']['xmx_ratio']).floor / 1024}m"
default['tomcat']['share_tomcat_instance']['java_options']['xmx_memory'] = "-Xmx#{share_memory}"

default['tomcat']['solr_tomcat_instance']['port'] = 8090
default['tomcat']['solr_tomcat_instance']['ssl_port'] = node['tomcat']['ssl_port']
default['tomcat']['solr_tomcat_instance']['ssl_proxy_port'] = node['tomcat']['ssl_proxy_port']
default['tomcat']['solr_tomcat_instance']['shutdown_port'] = -1
default['tomcat']['solr_tomcat_instance']['jmx_port'] = 40020
default['tomcat']['solr_tomcat_instance']['xmx_ratio'] = 0.3
solr_memory = "#{(memory_total.to_i * node['tomcat']['solr_tomcat_instance']['xmx_ratio']).floor / 1024}m"
default['tomcat']['solr_tomcat_instance']['java_options']['xmx_memory'] = "-Xmx#{solr_memory}"

default['tomcat']['base_version'] = 7
default['tomcat']['single_instance'] = 'alfresco'
default['tomcat']['user'] = node['appserver']['user']
default['tomcat']['group'] = node['appserver']['group']

default['tomcat']['jmxremote_path'] = lazy { "#{node['appserver']['alfresco']['home']}/conf" }
default['tomcat']['jmxremote_access_filename'] = 'jmxremote.access'
default['tomcat']['jmxremote_password_filename'] = 'jmxremote.password'
jmxremote_access_fullpath = lazy { "#{node['tomcat']['jmxremote_path']}/#{node['tomcat']['jmxremote_access_filename']}" }
jmxremote_password_fullpath = lazy { "#{node['tomcat']['jmxremote_path']}/#{node['tomcat']['jmxremote_password_filename']}" }

default['artifacts']['catalina-jmx']['destination'] = lazy { "#{node['appserver']['alfresco']['home']}/lib" }
default['artifacts']['memcached-session-manager']['destination'] = lazy { "#{node['appserver']['alfresco']['home']}/lib" }
default['artifacts']['memcached-session-manager-tc7']['destination'] = lazy { "#{node['appserver']['alfresco']['home']}/lib" }
default['artifacts']['spymemcached']['destination'] = lazy { "#{node['appserver']['alfresco']['home']}/lib" }
default['artifacts']['msm-kryo-serializer']['destination'] = lazy { "#{node['appserver']['alfresco']['home']}/lib" }
default['artifacts']['kryo-serializers']['destination'] = lazy { "#{node['appserver']['alfresco']['home']}/lib" }
default['artifacts']['kryo']['destination'] = lazy { "#{node['appserver']['alfresco']['home']}/lib" }
default['artifacts']['minlog']['destination'] = lazy { "#{node['appserver']['alfresco']['home']}/lib" }
default['artifacts']['reflectasm']['destination'] = lazy { "#{node['appserver']['alfresco']['home']}/lib" }
default['artifacts']['asm']['destination'] = lazy { "#{node['appserver']['alfresco']['home']}/lib" }
default['artifacts']['objenesis']['destination'] = lazy { "#{node['appserver']['alfresco']['home']}/lib" }

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

default['tomcat']['repo_tomcat_instance']['java_options']['rmi_and_alfhome'] = lazy { "-Dalfresco.home=#{node['appserver']['alfresco']['home']}/alfresco -Djava.rmi.server.hostname=#{node['appserver']['alfresco']['rmi_server_hostname']}" }
default['tomcat']['repo_tomcat_instance']['java_options']['log_paths'] = lazy { "-Djava.util.logging.config.file=#{node['appserver']['alfresco']['home']}/alfresco/conf/logging.properties -Dlog4j.configuration=alfresco/log4j.properties -Xloggc:#{node['appserver']['alfresco']['home']}/alfresco/logs/gc.log -Dlogfilename=#{node['appserver']['alfresco']['home']}/alfresco/logs/alfresco.log -XX:ErrorFile=#{node['appserver']['alfresco']['home']}/alfresco/logs/jvm_crash%p.log -XX:HeapDumpPath=#{node['appserver']['alfresco']['home']}/alfresco/logs/" }

default['tomcat']['share_tomcat_instance']['java_options']['rmi'] = lazy { "-Djava.rmi.server.hostname=#{node['appserver']['alfresco']['rmi_server_hostname']}" }
default['tomcat']['share_tomcat_instance']['java_options']['log_paths'] = lazy { "-Djava.util.logging.config.file=#{node['appserver']['alfresco']['home']}/share/conf/logging.properties -Dlog4j.configuration=alfresco/log4j.properties -Xloggc:#{node['appserver']['alfresco']['home']}/share/logs/gc.log -Dlogfilename=#{node['appserver']['alfresco']['home']}/share/logs/share.log -XX:ErrorFile=#{node['appserver']['alfresco']['home']}/share/logs/jvm_crash%p.log -XX:HeapDumpPath=#{node['appserver']['alfresco']['home']}/share/logs/" }

default['tomcat']['solr_tomcat_instance']['java_options']['rmi_and_solr'] = lazy { "-Djava.rmi.server.hostname=#{node['appserver']['alfresco']['rmi_server_hostname']} -Dsolr.solr.model.dir=#{node['appserver']['alfresco']['solr']['alfresco_models']} -Dsolr.solr.home=#{node['appserver']['alfresco']['solr']['home']} -Dsolr.solr.content.dir=#{node['appserver']['alfresco']['solr']['contentstore.path']}" }
default['tomcat']['solr_tomcat_instance']['java_options']['log_paths'] = lazy { "-Djava.util.logging.config.file=#{node['appserver']['alfresco']['home']}/solr/conf/logging.properties -Dlog4j.configuration=alfresco/log4j.properties -Xloggc:#{node['appserver']['alfresco']['home']}/solr/gc.log -Dlogfilename=#{node['appserver']['alfresco']['home']}/solr/logs/solr.log -XX:ErrorFile=#{node['appserver']['alfresco']['home']}/solr/logs/jvm_crash%p.log -XX:HeapDumpPath=#{node['appserver']['alfresco']['home']}/solr/logs/" }

default['tomcat']['global_templates'] = [{
  'dest' => node['tomcat']['jmxremote_path'],
  'filename' => node['tomcat']['jmxremote_access_filename'],
  'owner' => node['tomcat']['user'],
}, {
  'dest' => node['tomcat']['jmxremote_path'],
  'filename' => node['tomcat']['jmxremote_password_filename'],
  'owner' => node['tomcat']['user'],
}, {
  'dest' => "#{node['appserver']['alfresco']['home']}/lib/org/apache/catalina/util",
  'filename' => 'ServerInfo.properties',
  'owner' => node['tomcat']['user'],
}, {
  'dest' => '/etc/security/limits.d',
  'filename' => 'tomcat_limits.conf',
  'owner' => node['tomcat']['user'],
}, {
  'dest' => "#{node['appserver']['alfresco']['home']}/share/conf/Catalina/localhost",
  'filename' => 'share.xml',
  'owner' => node['tomcat']['user'],
  'onlyIf' => !node['tomcat']['memcached_nodes'].empty? && node['appserver']['alfresco']['components'].include?('share'),
}]
