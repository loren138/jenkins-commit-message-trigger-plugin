Jenkins::Plugin::Specification.new do |plugin|
  plugin.name = "ci-build"
  plugin.display_name = "Ci Build Plugin"
  plugin.version = '0.1'
  plugin.description = 'This plugin allows builds to be made only for certain commit text in the commit message.'

  # You should create a wiki-page for your plugin when you publish it, see
  # https://wiki.jenkins-ci.org/display/JENKINS/Hosting+Plugins#HostingPlugins-AddingaWikipage
  # This line makes sure it's listed in your POM.
  plugin.url = 'https://wiki.jenkins-ci.org/display/JENKINS/Ci+Build+Plugin'

  # The first argument is your user name for jenkins-ci.org.
  plugin.developed_by "wiseloren", "Loren Klingman"

  # This specifies where your code is hosted.
  # Alternatives include:
  #  :github => 'myuser/ci-build-plugin' (without myuser it defaults to jenkinsci)
  #  :git => 'git://repo.or.cz/ci-build-plugin.git'
  #  :svn => 'https://svn.jenkins-ci.org/trunk/hudson/plugins/ci-build-plugin'
  plugin.uses_repository :github => "jenkins-ci-build-plugin"

  # This is a required dependency for every ruby plugin.
  plugin.depends_on 'ruby-runtime', '0.12'
end
