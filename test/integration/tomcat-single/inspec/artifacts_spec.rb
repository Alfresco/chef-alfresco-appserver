control 'artifact-existance' do
  impact 0.7
  title 'Artifact Existance'
  desc 'Checks that artifacts have been correctly downloaded and moved'

  describe file('/usr/share/tomcat/lib/catalina-jmx.jar') do
    it { should exist }
    it { should be_owned_by 'tomcat' }
  end
end
