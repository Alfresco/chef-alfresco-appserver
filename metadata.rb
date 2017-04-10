name 'alfresco-appserver'
maintainer 'Alfresco Tooling & Automation'
maintainer_email 'marco.mancuso@alfresco.com'
license 'Apache 2.0'
description 'Installs/Configures chef-alfresco-appserver'
long_description 'Installs/Configures chef-alfresco-appserver'
version '0.1'

chef_version '~> 12'

issues_url       'https://github.com/Alfresco/chef-alfresco-appserver/issues'
source_url       'https://github.com/Alfresco/chef-alfresco-appserver'

supports 'centos', '>= 7.0'

depends 'file'
depends 'apache_tomcat'
depends 'poise-derived', '~> 1.0.0'
depends 'commons'
depends 'alfresco-utils'
# depends 'openssl', '>= 4.0.0'
