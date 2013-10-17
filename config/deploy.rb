#set :svn_username, "apache"
set :svn_username, "www"
set :application, "orchive"
set :domain, "o"
set :deploy_to, "/var/www/orchive"
set :repository, "svn+ssh://q/usr/sness/nDEVsvn/orchive"

namespace :vlad do
  set :app_command, "/etc/init.d/apache2"
end
