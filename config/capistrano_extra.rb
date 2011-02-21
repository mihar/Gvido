unless Capistrano::Configuration.respond_to?(:instance)
  abort "This extension requires Capistrano 2"
end

Capistrano::Configuration.instance.load do

  namespace :db do

    desc <<-DESC
      Creates the database.yml configuration file in shared path.
    DESC
    task :setup, :except => { :no_release => true } do

      default_db_template = <<-EOF
      base: &base
        adapter: sqlite3
        timeout: 5000
      development:
        database: #{shared_path}/db/development.sqlite3
        <<: *base
      test:
        database: #{shared_path}/db/test.sqlite3
        <<: *base
      production:
        database: #{shared_path}/db/production.sqlite3
        <<: *base
      EOF

      db_location = fetch(:template_dir, "./config/deploy") + '/database.yml.erb'
      db_template = File.file?(db_location) ? File.read(db_location) : default_db_template
      db_config = ERB.new(db_template)

      run "mkdir -p #{shared_path}/db"
      run "mkdir -p #{shared_path}/config"
      put db_config.result(binding), "#{shared_path}/config/database.yml"
    end

    desc <<-DESC
      [internal] Updates the symlink for database.yml and double_recall.yml file to the just deployed release.
    DESC
    task :symlink, :except => { :no_release => true } do
      run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
    end

  end

  after "deploy:setup",           "db:setup"   unless fetch(:skip_db_setup, false)
  after "deploy:finalize_update", "db:symlink"

end