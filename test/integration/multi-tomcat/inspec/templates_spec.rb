control 'templates-existance' do
  impact 0.7
  title 'Templates Existance'
  desc 'Checks that templates have been correctly created'

  instance = 'tomcat-multi'
  components = %w(alfresco share solr)

  components.each do |component|
    describe file("/etc/cron.d/#{component}-cleaner.cron") do
      it { should be_file }
      it { should exist }
      its('owner') { should eq 'root' }
      its('content') { should match "/usr/share/#{instance}/#{component}/logs" }
    end
  end

  describe file("/usr/share/#{instance}/conf/context.xml") do
    it { should be_file }
    it { should exist }
    its('owner') { should eq 'tomcat' }
  end

  components.each do |component|
    describe file("/usr/share/#{instance}/#{component}/conf/context.xml") do
      it { should be_file }
      it { should exist }
      its('owner') { should eq 'tomcat' }
    end
  end

  describe file("/usr/share/#{instance}/conf/jmxremote.access") do
    it { should be_file }
    it { should exist }
    its('owner') { should eq 'tomcat' }
    its('content') { should match 'systemsMonitorRole  readonly' }
    its('content') { should match 'systemsControlRole  readwrite create javax.management.monitor.*,javax.management.timer.* unregister' }
  end

  describe file("/usr/share/#{instance}/conf/jmxremote.password") do
    it { should be_file }
    it { should exist }
    its('owner') { should eq 'tomcat' }
    its('content') { should match 'systemsMonitorRole   changeme' }
    its('content') { should match 'systemsControlRole   changeme' }
  end

  describe file("/usr/share/#{instance}/conf/logging.properties") do
    it { should be_file }
    it { should exist }
    its('owner') { should eq 'tomcat' }
    its('content') { should match '.level = INFO' }
  end

  describe file("/usr/share/#{instance}/alfresco/conf/server.xml") do
    it { should be_file }
    it { should exist }
    its('owner') { should eq 'tomcat' }
    its('content') { should_not match 'secure=\"true\"' }
    its('content') { should match 'Connector port=\"8070\"' }
    its('content') { should_not match 'Connector port=\"8081\"' }
    its('content') { should_not match 'Connector port=\"8090\"' }
  end

  describe file("/usr/share/#{instance}/share/conf/server.xml") do
    it { should be_file }
    it { should exist }
    its('owner') { should eq 'tomcat' }
    its('content') { should_not match 'secure=\"true\"' }
    its('content') { should match 'Connector port=\"8081\"' }
    its('content') { should_not match 'Connector port=\"8070\"' }
    its('content') { should_not match 'Connector port=\"8090\"' }
  end

  describe file("/usr/share/#{instance}/solr/conf/server.xml") do
    it { should be_file }
    it { should exist }
    its('owner') { should eq 'tomcat' }
    its('content') { should_not match 'secure=\"true\"' }
    its('content') { should match 'Connector port=\"8090\"' }
    its('content') { should_not match 'Connector port=\"8070\"' }
    its('content') { should_not match 'Connector port=\"8081\"' }
  end

  # describe file("/usr/share/#{instance}/lib/org/apache/catalina/util/ServerInfo.properties") do
  #   it { should be_file }
  #   it { should exist }
  #   its('owner') { should eq 'tomcat' }
  #   its('content') { should match 'server.info=Alfresco \(localhost\)' }
  # end

  describe file("/usr/share/#{instance}/share/conf/Catalina/localhost/share.xml") do
    it { should be_file }
    it { should exist }
    its('owner') { should eq 'tomcat' }
  end

  describe file('/etc/security/limits.d/tomcat_limits.conf') do
    it { should be_file }
    it { should exist }
    its('owner') { should eq 'tomcat' }
  end
end
