set :deploy_to, "/webroot/gvido"
set :branch, "master"
set :use_sudo, false
set :user, "deploy"
set :rails_env, "staging"
server "staging.disru.pt:900", :app, :web, :db, :primary => true