# chef-alfresco-appserver cookbook
[![Build Status](https://travis-ci.org/Alfresco/chef-alfresco-appserver.svg)](https://travis-ci.org/Alfresco/chef-alfresco-appserver)
[![Cookbook](http://img.shields.io/cookbook/v/alfresco-appserver.svg)](https://github.com/Alfresco/chef-alfresco-appserver)
[![Coverage Status](https://coveralls.io/repos/github/Alfresco/chef-alfresco-appserver/badge.svg)](https://coveralls.io/github/Alfresco/chef-alfresco-appserver)

This cookbook will install the Application Server part of the Alfresco stack.
The default choice is Tomcat, but it can be expanded to use your own application server.

## Attributes


| Key | Type | Description | Default |
|-----|------|-------------|---------|
| default['appserver']['engine'] | String | Engine of choice  | tomcat  |
| default['appserver']['port'] | Int  |  appserver public port |  80 |
| default['appserver']['port_ssl'] | Int  |  Public SSL Port |  443 |
| default['appserver']['hostname']  | String  | Matching hostname  |  localhost |
| default['appserver']['lb_hostname'] | String | Hostname/Address of the internal load-balancer  | 127.0.0.1  |
| default['appserver']['lb_protocol'] | String  |  Protocol used to talk to the internal load-balancer |  http |
| default['appserver']['lb_port'] | Int  | Port of the internal load-balancer | 9001 |
| default['appserver']['use_nossl_config']  | Boolean  | Wheter to avoid or use ssl |  true |
| default['appserver']['certs']['filename']  | String  | SSL Certs filename  |  alfresco |
| default['appserver']'certs']['ssl_folder']| String | Folder where the SSL certs will be stored  | /etc/pki/tls/certs  |
| default['appserver']['error_pages']['error_folder'] | String  |  Where the error pages will be stored |  /var/www/html/error_pages |
| default['appserver']['apply_hardening'] | Boolean  | Weter you want this installation to be hardened or no | true |
