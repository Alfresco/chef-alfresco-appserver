control 'templates\-existance' do
  impact 0.7
  title 'Templates Existance'
  desc 'Checks that templates have been correctly created'

  components = %w(alfresco share solr)

  components.each do |component|
    describe file("/usr/share/tomcat/#{component}/bin/setenv.sh") do
      it { should be_file }
      it { should exist }
      its('owner') { should eq 'tomcat' }
      its('content') { should match '\-XX:\+UseCompressedOops' }
      its('content') { should match '\-XX:\+DisableExplicitGC' }
      its('content') { should match '\-XX:\+PrintGCDetails' }
      its('content') { should match '\-verbose:gc' }
      its('content') { should match '\-Djava.net.preferIPv4Stack=true' }
      its('content') { should match '\-Djava.net.preferIPv4Addresses=true' }
      its('content') { should match '\-Dsun.net.inetaddr.ttl=0' }
      its('content') { should match '\-Dsun.net.inetaddr.negative.ttl=0' }
      its('content') { should match '\-Dsun.security.ssl.allowUnsafeRenegotiation=true' }
      its('content') { should match '\-Dhazelcast.logging.type=log4j' }
      its('content') { should match '\-Djava.library.path=/usr/lib64' }
      its('content') { should match '\-Djava.awt.headless=true' }
      its('content') { should match '\-Dcom.sun.management.jmxremote=true' }
      its('content') { should match '\-Dcom.sun.management.jmxremote.authenticate=true' }
      its('content') { should match '\-Dcom.sun.management.jmxremote' }
      its('content') { should match '\-Dcom.sun.management.jmxremote.ssl=false' }
      its('content') { should match '\-Dcom.sun.management.jmxremote.access.file=/usr/share/tomcat/conf/jmxremote.access' }
      its('content') { should match '\-Dcom.sun.management.jmxremote.password.file=/usr/share/tomcat/conf/jmxremote.password' }
      if component == 'alfresco'
        its('content') { should match '\-Dalfresco.home=/usr/share/tomcat/alfresco' }
        its('content') { should match '\-Djava.rmi.server.hostname=localhost' }
        its('content') { should match '\-XX:\+PrintGCTimeStamps' }
      end
      if component == 'solr'
        its('content') { should match '\-Dsolr.solr.home=/usr/share/tomcat/alf_data/solrhome' }
        its('content') { should match '\-Dsolr.solr.content.dir=/usr/share/tomcat/alf_data/solrContentStore' }
        its('content') { should match '\-Dsolr.solr.model.dir=/usr/share/tomcat/alf_data/newAlfrescoModels' }
      end
      its('content') { should match "\-Djava.util.logging.config.file=/usr/share/tomcat/#{component}/conf/logging.properties" }
      its('content') { should match '\-Dlog4j.configuration=alfresco/log4j.properties' }
      if component == 'alfresco' || component == 'share'
        its('content') { should match "\-Dlogfilename=/usr/share/tomcat/#{component}/logs/#{component}.log" }
      end
      its('content') { should match "\-XX:ErrorFile=/usr/share/tomcat/#{component}/logs/jvm_crash%p.log" }
      its('content') { should match "\-XX:HeapDumpPath=/usr/share/tomcat/#{component}/logs/" }
    end
  end

  folders = %w(/usr/share/tomcat/share/ /usr/share/tomcat/solr/ /usr/share/tomcat/alfresco/ /usr/share/tomcat/conf/ /usr/share/tomcat/lib/ /usr/share/tomcat/bin/ )
  folders.each do |folder|
    describe directory(folder) do
      it { should exist }
      it { should be_owned_by 'tomcat' }
    end
  end

  describe file('/usr/share/tomcat') do
    it { should be_symlink }
    it { should exist }
    it { should be_linked_to '/usr/share/tomcat-7.0.59' }
    it { should be_owned_by 'tomcat' }
  end

  describe file('/usr/share/tomcat/bin/catalina.sh') do
    it { should be_file }
    it { should exist }
    it { should be_owned_by 'tomcat' }
  end

  folders = %w(bin conf lib logs temp webapps work )
  components.each do |component|
    folders.each do |folder|
      describe directory("/usr/share/tomcat/#{component}/#{folder}") do
        it { should exist }
        it { should be_owned_by 'tomcat' }
      end
    end
  end
end
