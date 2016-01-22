require 'bundler/capistrano'
set :rvm_ruby_string, '2.1.6'
require "rvm/capistrano"
require 'capistrano-db-tasks'

load "config/recipes/base"
load "config/recipes/unicorn"

default_run_options[:pty] = true
set :application, 'deletecommentbot'
set :repository,  'git@git.pixelforcesystems.com.au:pixelforce-systems/deletecommentbot.git'
set :scm, :git

set :deploy_to,   '/home/deploy/deletecommentbot'
set :user,        'deploy'
set :branch,      'master'
set :rails_env,   'production'
set :migrate_env, 'production'
set :use_sudo, false
set :deploy_via, :remote_cache
set :db_local_clean, false
set :locals_rails_env, "development"
set :server_address, "deletecommentbot.com.au"

server "162.242.218.110", :app, :web, :db, :primary => true

# if you want to clean up old releases on each deploy uncomment this:
after "deploy:restart", "deploy:cleanup"
after 'deploy:restart', 'unicorn:restart'

after "bundle:install", :roles => :web do
  run "ln -s #{shared_path}/config/database.yml #{release_path}/config/database.yml"
end

# If you are using Passenger mod_rails uncomment this:
namespace :deploy do
  task :start do ; end  
  task :stop do ; end  
  task :restart, :roles => :app, :except => { :no_release => true } do
  end
end