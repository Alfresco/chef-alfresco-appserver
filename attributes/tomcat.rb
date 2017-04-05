default['tomcat']['tar']['url'] = 'http://archive.apache.org/dist/tomcat/tomcat-7/v7.0.59/bin/apache-tomcat-7.0.59.tar.gz'
# Note: Checksum is SHA-256, not MD5 or SHA1. Generate using `shasum -a 256 /path/to/tomcat.tar.gz`
default['tomcat']['tar']['checksum'] = 'e0fe43d1fa17013bf7b3b2d3f71105d606a0582c153eb16fb210e7d5164941b0'
default['tomcat']['tar']['version'] = '7.0.59'

# Tomcat attributes for base instance
default['tomcat']['port'] = 8080
default['tomcat']['proxy_port'] = nil
default['tomcat']['ssl_port'] = 8443
default['tomcat']['ssl_proxy_port'] = nil
default['tomcat']['ajp_port'] = 8009
default['tomcat']['jmx_port'] = nil
default['tomcat']['shutdown_port'] = 8005
default['tomcat']['catalina_options'] = ''
default['tomcat']['open_files_limit'] = 16000
default['tomcat']['processes_limit'] = 65000

memory_total = node['memory']['total']

default['tomcat']['java_options']['memory'] = "-Xmx#{(memory_total.to_i * 0.6).floor / 1024}m -Djava.awt.headless=true"
default['tomcat']['use_security_manager'] = false
default['tomcat']['authbind'] = 'no'
default['tomcat']['deploy_manager_apps'] = true
default['tomcat']['max_threads'] = nil
default['tomcat']['ssl_max_threads'] = 150
default['tomcat']['ssl_cert_file'] = nil
default['tomcat']['ssl_key_file'] = nil
default['tomcat']['ssl_chain_files'] = []
default['tomcat']['keystore_file'] = 'keystore.jks'
default['tomcat']['keystore_type'] = 'jks'
default['tomcat']['truststore_file'] = nil
default['tomcat']['truststore_type'] = 'jks'
default['tomcat']['certificate_dn'] = 'cn=localhost'
default['tomcat']['loglevel'] = 'INFO'
default['tomcat']['tomcat_auth'] = 'true'
default['tomcat']['instances'] = {}
default['tomcat']['keytool'] = 'keytool'

default['tomcat']['files_cookbook'] = 'alfresco'
default['tomcat']['deploy_manager_apps'] = false
default['tomcat']['jvm_memory'] = '-Xmx1500M'

default['tomcat']['maxHttpHeaderSize'] = '1048576'

default['tomcat']['cleaner.minutes.interval'] = 30
default['tomcat']['cache_root_folder'] = '/var/cache'

# Tomcat default settings
default['tomcat']['service_actions'] = [:disable, :stop]
default['tomcat']['restart_action'] = :nothing
default['tomcat']['deploy_manager_apps'] = false
default['tomcat']['use_security_manager'] = false

default['tomcat']['memcached_nodes'] = ''

default['tomcat']['additional_tomcat_packages'] = %w(tomcat-native apr)

# Use multi-homed tomcat installation
default['tomcat']['run_single_instance'] = false

# Context.xml settings
default['tomcat']['swallow_output'] = true
default['tomcat']['use_http_only'] = true

# Fixes keytool file missing, though shouldnt be needed due to java alternatives
default['tomcat']['keytool'] = '/usr/lib/jvm/java/bin/keytool'

default['tomcat']['server_template_cookbook'] = 'alfresco-appserver'
default['tomcat']['server_template_source'] = 'tomcat/server.xml.erb'
default['tomcat']['context_template_cookbook'] = 'alfresco-appserver'
default['tomcat']['context_template_source'] = 'tomcat/context.xml.erb'

# See templates/default[/tomcat/controller-info.xml
default['tomcat']['application_name'] = 'AlfrescoCloud.local'
default['tomcat']['tier_name'] = 'allinone-tier'
default['tomcat']['node_name'] = 'allinone-node'

default['tomcat']['instance_templates'] =
  [
    {
      'dest' => '/etc/cron.d',
      'filename' => 'cleaner.cron',
      'owner' => 'root',
    },
  ]

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
# default['tomcat']['share_tomcat_instance']['java_options']['log_paths'] = '-Xloggc:/var/log/tomcat-share/gc.log -Dlogfilename=/var/log/tomcat-share/share.log -Dlog4j.configuration=alfresco/log4j.properties -XX:ErrorFile=/var/log/tomcat-share/jvm_crash%p.log -XX:HeapDumpPath=/var/log/tomcat-share/'

default['tomcat']['solr_tomcat_instance']['port'] = 8090
default['tomcat']['solr_tomcat_instance']['shutdown_port'] = 8025
default['tomcat']['solr_tomcat_instance']['jmx_port'] = 40020
default['tomcat']['solr_tomcat_instance']['xmx_ratio'] = 0.3
solr_memory = "#{(memory_total.to_i * node['tomcat']['solr_tomcat_instance']['xmx_ratio']).floor / 1024}m"
default['tomcat']['solr_tomcat_instance']['java_options']['xmx_memory'] = "-Xmx#{solr_memory}"
# default['tomcat']['solr_tomcat_instance']['java_options']['log_paths'] = '-Xloggc:/var/log/tomcat-solr/gc.log -Dlogfilename=/var/log/tomcat-solr/solr.log -Dlog4j.configuration=alfresco/log4j.properties -XX:ErrorFile=/var/log/tomcat-solr/jvm_crash%p.log -XX:HeapDumpPath=/var/log/tomcat-solr/'

##############

default['tomcat']['base_version'] = 7

default['tomcat']['single_instance'] = 'alfresco'
default['tomcat']['user'] = 'tomcat'
default['tomcat']['group'] = 'tomcat'
default['tomcat']['home'] = '/usr/share/tomcat-single'
default['tomcat']['tomcat_single_path'] = lazy '%{tomcat.home}'
default['tomcat']['tomcat_multi_path'] = '/usr/share/tomcat-multi'


default['tomcat']['config_dir'] = lazy '%{tomcat.home}/conf'
default['tomcat']['webapp_dir'] = lazy '%{tomcat.home}/webapps'

default['appserver']['alfresco']['home'] = lazy { if node['tomcat']['run_single_instance']
                                                    node['tomcat']['tomcat_single_path']
                                                  else
                                                    node['tomcat']['tomcat_multi_path']
                                                  end
                                                }

default['tomcat']['jmxremote.access.file'] = lazy '%{appserver.alfresco.home}/conf/jmxremote.access'
default['tomcat']['jmxremote.password.file'] = lazy '%{appserver.alfresco.home}/conf/jmxremote.password'

default['artifacts']['catalina-jmx']['groupId'] = 'org.apache.tomcat'
default['artifacts']['catalina-jmx']['artifactId'] = 'tomcat-catalina-jmx-remote'
default['artifacts']['catalina-jmx']['version'] = '7.0.54'
default['artifacts']['catalina-jmx']['type'] = 'jar'
default['artifacts']['catalina-jmx']['destination'] =  lazy '%{appserver.alfresco.home}/lib'
default['artifacts']['catalina-jmx']['owner'] = node['appserver']['alfresco']['user']

default['artifacts']['memcached-session-manager']['groupId'] = 'de.javakaffee.msm'
default['artifacts']['memcached-session-manager']['artifactId'] = 'memcached-session-manager'
default['artifacts']['memcached-session-manager']['version'] = '1.9.3'
default['artifacts']['memcached-session-manager']['type'] = 'jar'
default['artifacts']['memcached-session-manager']['destination'] = lazy '%{appserver.alfresco.home}/lib'
default['artifacts']['memcached-session-manager']['owner'] = node['appserver']['alfresco']['user']

default['artifacts']['memcached-session-manager-tc7']['groupId'] = 'de.javakaffee.msm'
default['artifacts']['memcached-session-manager-tc7']['artifactId'] = 'memcached-session-manager-tc7'
default['artifacts']['memcached-session-manager-tc7']['version'] = '1.9.3'
default['artifacts']['memcached-session-manager-tc7']['type'] = 'jar'
default['artifacts']['memcached-session-manager-tc7']['destination'] = lazy '%{appserver.alfresco.home}/lib'
default['artifacts']['memcached-session-manager-tc7']['owner'] = node['appserver']['alfresco']['user']

default['artifacts']['spymemcached']['groupId'] = 'net.spy'
default['artifacts']['spymemcached']['artifactId'] = 'spymemcached'
default['artifacts']['spymemcached']['version'] = '2.11.1'
default['artifacts']['spymemcached']['type'] = 'jar'
default['artifacts']['spymemcached']['destination'] = lazy '%{appserver.alfresco.home}/lib'
default['artifacts']['spymemcached']['owner'] = node['appserver']['alfresco']['user']

default['artifacts']['msm-kryo-serializer']['groupId'] = 'de.javakaffee.msm'
default['artifacts']['msm-kryo-serializer']['artifactId'] = 'msm-kryo-serializer'
default['artifacts']['msm-kryo-serializer']['version'] = '1.9.3'
default['artifacts']['msm-kryo-serializer']['type'] = 'jar'
default['artifacts']['msm-kryo-serializer']['destination'] = lazy '%{appserver.alfresco.home}/lib'
default['artifacts']['msm-kryo-serializer']['owner'] = node['appserver']['alfresco']['user']

default['artifacts']['kryo-serializers']['groupId'] = 'de.javakaffee'
default['artifacts']['kryo-serializers']['artifactId'] = 'kryo-serializers'
default['artifacts']['kryo-serializers']['version'] = '0.34'
default['artifacts']['kryo-serializers']['type'] = 'jar'
default['artifacts']['kryo-serializers']['destination'] = lazy '%{appserver.alfresco.home}/lib'
default['artifacts']['kryo-serializers']['owner'] = node['appserver']['alfresco']['user']

default['artifacts']['kryo']['groupId'] = 'com.esotericsoftware'
default['artifacts']['kryo']['artifactId'] = 'kryo'
default['artifacts']['kryo']['version'] = '3.0.3'
default['artifacts']['kryo']['type'] = 'jar'
default['artifacts']['kryo']['destination'] = lazy '%{appserver.alfresco.home}/lib'
default['artifacts']['kryo']['owner'] = node['appserver']['alfresco']['user']

default['artifacts']['minlog']['groupId'] = 'com.esotericsoftware'
default['artifacts']['minlog']['artifactId'] = 'minlog'
default['artifacts']['minlog']['version'] = '1.3.0'
default['artifacts']['minlog']['type'] = 'jar'
default['artifacts']['minlog']['destination'] = lazy '%{appserver.alfresco.home}/lib'
default['artifacts']['minlog']['owner'] = node['appserver']['alfresco']['user']

default['artifacts']['reflectasm']['groupId'] = 'com.esotericsoftware'
default['artifacts']['reflectasm']['artifactId'] = 'reflectasm'
default['artifacts']['reflectasm']['version'] = '1.11.3'
default['artifacts']['reflectasm']['type'] = 'jar'
default['artifacts']['reflectasm']['destination'] = lazy '%{appserver.alfresco.home}/lib'
default['artifacts']['reflectasm']['owner'] = node['appserver']['alfresco']['user']

default['artifacts']['asm']['groupId'] = 'org.ow2.asm'
default['artifacts']['asm']['artifactId'] = 'asm'
default['artifacts']['asm']['version'] = '5.1'
default['artifacts']['asm']['type'] = 'jar'
default['artifacts']['asm']['destination'] = lazy '%{appserver.alfresco.home}/lib'
default['artifacts']['asm']['owner'] = node['appserver']['alfresco']['user']

default['artifacts']['objenesis']['groupId'] = 'org.objenesis'
default['artifacts']['objenesis']['artifactId'] = 'objenesis'
default['artifacts']['objenesis']['version'] = '2.4'
default['artifacts']['objenesis']['type'] = 'jar'
default['artifacts']['objenesis']['destination'] = lazy '%{appserver.alfresco.home}/lib'
default['artifacts']['objenesis']['owner'] = node['appserver']['alfresco']['user']

# attributes for share.xml.erb
default['tomcat']['memcached']['sticky'] = true
default['tomcat']['memcached']['sessionBackupAsync'] = true
default['tomcat']['memcached']['copyCollectionsForSerialization'] = false

default['tomcat']['jvm_route'] = node['appserver']['alfresco']['public_hostname']

# default['tomcat']['global_templates'] = lazy {[{
#   'dest' => "#{node['appserver']['alfresco']['home']}/conf",
#   'filename' => 'jmxremote.access',
#   'owner' => 'tomcat',
# }, {
#   'dest' => "#{node['appserver']['alfresco']['home']}/conf",
#   'filename' => 'jmxremote.password',
#   'owner' => 'tomcat',
# }, {
#   'dest' => "#{node['appserver']['alfresco']['home']}#{'/alfresco' unless node['tomcat']['run_single_instance']}/lib/org/apache/catalina/util",
#   'filename' => 'ServerInfo.properties',
#   'owner' => 'tomcat',
# }, {
#   'dest' => '/etc/security/limits.d',
#   'filename' => 'tomcat_limits.conf',
#   'owner' => 'tomcat',
# }]}

# Setting JAVA_OPTS
default['tomcat']['java_options_hash']['jmx'] = lazy {"-Dcom.sun.management.jmxremote=true  -Dcom.sun.management.jmxremote.authenticate=true -Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.ssl=false -Dcom.sun.management.jmxremote.access.file=#{node['tomcat']['jmxremote.access.file']} -Dcom.sun.management.jmxremote.password.file=#{node['tomcat']['jmxremote.password.file']}"}

default['tomcat']['repo_tomcat_instance']['java_options'] = node['tomcat']['java_options_hash']
default['tomcat']['share_tomcat_instance']['java_options'] = node['tomcat']['java_options_hash']
default['tomcat']['solr_tomcat_instance']['java_options'] = node['tomcat']['java_options_hash']

default['tomcat']['ssl_enabled'] = true
