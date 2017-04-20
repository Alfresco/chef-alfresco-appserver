control 'templates-existance' do
  impact 0.7
  title 'Templates Existance'
  desc 'Checks that templates have been correctly created'

  components = %w(alfresco share solr)

  components.each do |component|
    describe file("/etc/cron.d/#{component}-cleaner.cron") do
      it { should be_file }
      it { should exist }
      its('owner') { should eq 'root' }
      its('content') { should match "/usr/share/tomcat/#{component}/logs" }
    end
  end

  describe file('/usr/share/tomcat/conf/context.xml') do
    it { should be_file }
    it { should exist }
    its('owner') { should eq 'tomcat' }
  end

  components.each do |component|
    describe file("/usr/share/tomcat/#{component}/conf/context.xml") do
      it { should be_file }
      it { should exist }
      its('owner') { should eq 'tomcat' }
    end
  end

  describe file('/usr/share/tomcat/conf/jmxremote.access') do
    it { should be_file }
    it { should exist }
    its('owner') { should eq 'tomcat' }
    its('content') { should match 'systemsMonitorRole  readonly' }
    its('content') { should match 'systemsControlRole  readwrite create javax.management.monitor.*,javax.management.timer.* unregister' }
  end

  describe file('/usr/share/tomcat/conf/jmxremote.password') do
    it { should be_file }
    it { should exist }
    its('owner') { should eq 'tomcat' }
    its('content') { should match 'systemsMonitorRole   changeme' }
    its('content') { should match 'systemsControlRole   changeme' }
  end

  describe file('/usr/share/tomcat/conf/logging.properties') do
    it { should be_file }
    it { should exist }
    its('owner') { should eq 'tomcat' }
    its('content') { should match '.level = INFO' }
  end

  components.each do |component|
    describe file("/usr/share/tomcat/#{component}/conf/server.xml") do
      it { should be_file }
      it { should exist }
      its('owner') { should eq 'tomcat' }
      its('content') { should match 'secure=\"true\"' }
      if component == 'alfresco'
        its('content') { should match 'Connector port=\"8070\"' }
        its('content') { should_not match 'Connector port=\"8081\"' }
        its('content') { should_not match 'Connector port=\"8090\"' }
      end
      if component == 'share'
        its('content') { should match 'Connector port=\"8081\"' }
        its('content') { should_not match 'Connector port=\"8070\"' }
        its('content') { should_not match 'Connector port=\"8090\"' }
      end
      if component == 'solr'
        its('content') { should match 'Connector port=\"8090\"' }
        its('content') { should_not match 'Connector port=\"8081\"' }
        its('content') { should_not match 'Connector port=\"8070\"' }
      end
    end
  end

  describe file('/usr/share/tomcat/share/conf/Catalina/localhost/share.xml') do
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
