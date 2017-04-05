# these attributes will be overriden by wrapping cookbook chef-alfresco
default['appserver']['alfresco']['components'] = %w(repo share solr)
default['appserver']['alfresco']['home'] = '/usr/share/tomcat'
default['appserver']['alfresco']['user'] = 'tomcat'
default['appserver']['alfresco']['public_hostname'] = 'localhost'
default['appserver']['alfresco']['rmi_server_hostname'] = 'localhost'
# default['appserver']['alfresco']['jmxremote_databag'] = ''
# default['appserver']['alfresco']['jmxremote_databag_items'] = ''
default['appserver']['alfresco']['solr']['home'] = '/usr/share/tomcat/alf_data/solrhome'
default['appserver']['alfresco']['solr']['alfresco_models'] = '/usr/share/tomcat/alf_data/newAlfrescoModels'
default['appserver']['alfresco']['solr']['contentstore.path'] = '/usr/share/tomcat/alf_data/solrContentStore'
default['appserver']['alfresco']['keystore_file'] = '/usr/share/tomcat/alf_data/keystore/alfresco/keystore/ssl.keystore'
default['appserver']['alfresco']['keystore_password'] = 'test'
default['appserver']['alfresco']['keystore_type'] = 'test'
default['appserver']['alfresco']['truststore_file'] = 'test'
default['appserver']['alfresco']['truststore_type'] = 'test'
default['appserver']['alfresco']['truststore_password'] = 'test'
default['appserver']['alfresco']['server_info'] = 'Alfresco (localhost)'

# appserver specific attributes
default['appserver']['download_artifacts'] = false
default['appserver']['engine'] = 'tomcat'
default['appserver']['install_java'] = false
default['appserver']['install_maven'] = false
