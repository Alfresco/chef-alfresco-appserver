appserver_user = node['appserver']['user']

default['artifacts']['catalina-jmx']['groupId'] = 'org.apache.tomcat'
default['artifacts']['catalina-jmx']['artifactId'] = 'tomcat-catalina-jmx-remote'
default['artifacts']['catalina-jmx']['version'] = '7.0.54'
default['artifacts']['catalina-jmx']['type'] = 'jar'
default['artifacts']['catalina-jmx']['owner'] = appserver_user

default['artifacts']['memcached-session-manager']['groupId'] = 'de.javakaffee.msm'
default['artifacts']['memcached-session-manager']['artifactId'] = 'memcached-session-manager'
default['artifacts']['memcached-session-manager']['version'] = '1.9.3'
default['artifacts']['memcached-session-manager']['type'] = 'jar'
default['artifacts']['memcached-session-manager']['owner'] = appserver_user

default['artifacts']['memcached-session-manager-tc7']['groupId'] = 'de.javakaffee.msm'
default['artifacts']['memcached-session-manager-tc7']['artifactId'] = 'memcached-session-manager-tc7'
default['artifacts']['memcached-session-manager-tc7']['version'] = '1.9.3'
default['artifacts']['memcached-session-manager-tc7']['type'] = 'jar'
default['artifacts']['memcached-session-manager-tc7']['owner'] = appserver_user

default['artifacts']['spymemcached']['groupId'] = 'net.spy'
default['artifacts']['spymemcached']['artifactId'] = 'spymemcached'
default['artifacts']['spymemcached']['version'] = '2.11.1'
default['artifacts']['spymemcached']['type'] = 'jar'
default['artifacts']['spymemcached']['owner'] = appserver_user

default['artifacts']['msm-kryo-serializer']['groupId'] = 'de.javakaffee.msm'
default['artifacts']['msm-kryo-serializer']['artifactId'] = 'msm-kryo-serializer'
default['artifacts']['msm-kryo-serializer']['version'] = '1.9.3'
default['artifacts']['msm-kryo-serializer']['type'] = 'jar'
default['artifacts']['msm-kryo-serializer']['owner'] = appserver_user

default['artifacts']['kryo-serializers']['groupId'] = 'de.javakaffee'
default['artifacts']['kryo-serializers']['artifactId'] = 'kryo-serializers'
default['artifacts']['kryo-serializers']['version'] = '0.34'
default['artifacts']['kryo-serializers']['type'] = 'jar'
default['artifacts']['kryo-serializers']['owner'] = appserver_user

default['artifacts']['kryo']['groupId'] = 'com.esotericsoftware'
default['artifacts']['kryo']['artifactId'] = 'kryo'
default['artifacts']['kryo']['version'] = '3.0.3'
default['artifacts']['kryo']['type'] = 'jar'
default['artifacts']['kryo']['owner'] = appserver_user

default['artifacts']['minlog']['groupId'] = 'com.esotericsoftware'
default['artifacts']['minlog']['artifactId'] = 'minlog'
default['artifacts']['minlog']['version'] = '1.3.0'
default['artifacts']['minlog']['type'] = 'jar'
default['artifacts']['minlog']['owner'] = appserver_user

default['artifacts']['reflectasm']['groupId'] = 'com.esotericsoftware'
default['artifacts']['reflectasm']['artifactId'] = 'reflectasm'
default['artifacts']['reflectasm']['version'] = '1.11.3'
default['artifacts']['reflectasm']['type'] = 'jar'
default['artifacts']['reflectasm']['owner'] = appserver_user

default['artifacts']['asm']['groupId'] = 'org.ow2.asm'
default['artifacts']['asm']['artifactId'] = 'asm'
default['artifacts']['asm']['version'] = '5.1'
default['artifacts']['asm']['type'] = 'jar'
default['artifacts']['asm']['owner'] = appserver_user

default['artifacts']['objenesis']['groupId'] = 'org.objenesis'
default['artifacts']['objenesis']['artifactId'] = 'objenesis'
default['artifacts']['objenesis']['version'] = '2.4'
default['artifacts']['objenesis']['type'] = 'jar'
default['artifacts']['objenesis']['owner'] = appserver_user
