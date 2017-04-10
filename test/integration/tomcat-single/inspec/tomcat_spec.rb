control 'templates\-existance' do
  impact 0.7
  title 'Templates Existance'
  desc 'Checks that templates have been correctly created'

  components = %w(alfresco share solr)

  describe file('/usr/share/tomcat/bin/setenv.sh') do
    it { should be_file }
    it { should exist }
    its('owner') { should eq 'tomcat' }
    its('content') { should match '\-Djava.awt.headless=true' }
    its('content') { should match '\-Dalfresco.home=/usr/share/tomcat' }
    its('content') { should match '\-Djava.rmi.server.hostname=localhost' }
    its('content') { should match '\-Dsolr.solr.home=/usr/share/tomcat/alf_data/solrhome' }
    its('content') { should match '\-Dsolr.solr.content.dir=/usr/share/tomcat/alf_data/solrContentStore' }
    its('content') { should match '\-Dsolr.solr.model.dir=/usr/share/tomcat/alf_data/newAlfrescoModels' }
    its('content') { should match '\-Djava.util.logging.config.file=/usr/share/tomcat/conf/logging.properties' }
    its('content') { should match '\-Dlog4j.configuration=alfresco/log4j.properties' }
    its('content') { should match '\-Dlogfilename=/usr/share/tomcat/logs/alfresco.log' }
    its('content') { should match '\-XX:ErrorFile=/usr/share/tomcat/logs/jvm_crash%p.log' }
    its('content') { should match '\-XX:HeapDumpPath=/usr/share/tomcat/logs/' }
  end

  describe file('/usr/share/tomcat') do
    it { should be_symlink }
    it { should exist }
    it { should be_linked_to '/usr/share/tomcat-7.0.59' }
    # it { should be_owned_by 'tomcat' }
  end

  describe file('/usr/share/tomcat/bin/catalina.sh') do
    it { should be_file }
    it { should exist }
    # it { should be_owned_by 'tomcat' }
  end

  folders = %w(bin conf lib logs temp webapps work )
  folders.each do |folder|
    describe directory("/usr/share/tomcat/#{folder}") do
      it { should exist }
      # it { should be_owned_by 'tomcat' }
    end
  end
end
