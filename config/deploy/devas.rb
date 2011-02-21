set :deploy_to, "/webroot/gvido"
set :branch, "master"
set :use_sudo, false
set :user, "deploy"
set :rails_env, "devas"
server "devas.disru.pt:910", :app, :web, :db, :primary => true