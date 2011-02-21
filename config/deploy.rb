require 'bundler/capistrano'
require "./config/capistrano_extra"

default_run_options[:pty] = true  # Must be set for the password prompt from git to work

set :application, "Gvido Rails 3"
set :repository,  "git@staging:gvidor3.git"
set :scm, :git
set :scm_verbose, true
set :deploy_via, :remote_cache

ssh_options[:compression] = "none"

# If you are using Passenger mod_rails uncomment this:
# if you're still using the script/reapear helper you will need
# these http://github.com/rails/irs_process_scripts

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end

task :uname do
  run "uname -a"
end

require 'config/boot'

# Hoptoad
require 'hoptoad_notifier/capistrano'
after "deploy:update", "deploy:notify_hoptoad"

        require 'config/boot'
        require 'hoptoad_notifier/capistrano'
