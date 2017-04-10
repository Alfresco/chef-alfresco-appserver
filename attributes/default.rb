# these attributes will be overriden by wrapping cookbook chef-alfresco
default['appserver']['alfresco']['components'] = %w(repo share solr)
default['appserver']['alfresco']['user'] = 'tomcat'
default['appserver']['alfresco']['public_hostname'] = 'localhost'
default['appserver']['alfresco']['rmi_server_hostname'] = 'localhost'
default['appserver']['alfresco']['jmxremote_databag'] = 'credentials'
default['appserver']['alfresco']['jmxremote_databag_items'] = %w(systemsmonitor systemscontrol)
default['appserver']['alfresco']['solr']['home'] = '/usr/share/tomcat/alf_data/solrhome'
default['appserver']['alfresco']['solr']['alfresco_models'] = '/usr/share/tomcat/alf_data/newAlfrescoModels'
default['appserver']['alfresco']['solr']['contentstore.path'] = '/usr/share/tomcat/alf_data/solrContentStore'
default['appserver']['alfresco']['keystore_file'] = '/usr/share/tomcat/alf_data/keystore/alfresco/keystore/ssl.keystore'
default['appserver']['alfresco']['keystore_password'] = 'kT9X6oe68t'
default['appserver']['alfresco']['keystore_type'] = 'JCEKS'
default['appserver']['alfresco']['home'] = lazy '/usr/share/tomcat'
default['appserver']['alfresco']['truststore_file'] = lazy '%{appserver.alfresco.home}/alf_data/keystore/alfresco/keystore/ssl.truststore'
default['appserver']['alfresco']['truststore_type'] = 'JCEKS'
default['appserver']['alfresco']['truststore_password'] = 'kT9X6oe68t'
default['appserver']['alfresco']['server_info'] = 'Alfresco (localhost)'
default['appserver']['ssl_enabled'] = true

# appserver specific attributes
default['appserver']['download_artifacts'] = false
default['appserver']['engine'] = 'tomcat'
default['appserver']['install_java'] = false
default['appserver']['install_maven'] = false
