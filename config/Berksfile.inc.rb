# Get configuration in both old and new way. This will eventually go away
#   in favor of 
OLD_CONF = File.join(File.dirname(__FILE__), 'Berksfile.conf.rb')
if File.exists? OLD_CONF
  echo "Please move Berksfile.conf.rb to Berksfile.conf"
  CONF = OLD_CONF
else
  CONF = File.join(File.dirname(__FILE__), 'Berksfile.conf')
end
require CONF if File.exists? CONF
%w[ USE_LOCAL LOCAL_PATH PANTRY_REPO PANTRY_BRANCH ].each do |var|
  ( ENV[var] = eval(var) ) rescue nil   unless ENV[var]
end

ENV['USE_LOCAL']        = false                               unless defined? ENV['USE_LOCAL']
ENV['LOCAL_PATH']       = "vendor"                            unless defined? ENV['LOCAL_PATH']
ENV['PANTRY_REPO']      = 'infochimps-labs/ironfan-pantry'    unless defined? ENV['PANTRY_REPO']
ENV['PANTRY_BRANCH']    = 'master'                            unless defined? ENV['PANTRY_BRANCH']

def github_cookbook(name, repo, rel, branch)
  if ENV['USE_LOCAL']
    r_name = repo.split('/')[1]
    cookbook name, path: "#{ENV['LOCAL_PATH']}/#{r_name}/#{rel}"
  else
    cookbook name, github: repo, protocol: 'ssh', rel: rel, branch: branch
  end
end

def pantry_cookbook(name)
  github_cookbook name, ENV['PANTRY_REPO'], ('cookbooks/' + name), ENV['PANTRY_BRANCH']
end

def org_cookbook(name)
  cookbook name, path: "org_cookbooks/#{name}"
end