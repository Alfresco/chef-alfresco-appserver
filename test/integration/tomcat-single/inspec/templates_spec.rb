control 'templates-existance' do
  impact 0.7
  title 'Templates Existance'
  desc 'Checks that templates have been correctly created'

  describe file('/etc/cron.d/alfresco-cleaner.cron') do
    it { should be_file }
    it { should exist }
    its('owner') { should eq 'root' }
    its('content') { should match '/usr/share/tomcat/logs' }
  end

  describe file('/usr/share/tomcat/conf/context.xml') do
    it { should be_file }
    it { should exist }
    its('owner') { should eq 'tomcat' }
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

  describe file('/usr/share/tomcat/conf/server.xml') do
    it { should be_file }
    it { should exist }
    its('owner') { should eq 'tomcat' }
    its('content') { should match 'secure=\"true\"' }
    its('content') { should match 'Connector port=\"8080\"' }
    its('content') { should_not match 'Connector port=\"8081\"' }
    its('content') { should_not match 'Connector port=\"8090\"' }
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
