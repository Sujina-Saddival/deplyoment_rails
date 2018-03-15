# config valid for current version and patch releases of Capistrano
lock "~> 3.10.1"

set :rbenv_type, :user
set :rbenv_ruby_version, 'ruby-2.3.0' # Edit this if you are using MRI Ruby

set :application, 'deployment-rails'
set :repo_url, 'git@github.com:Sujina-Saddival/deplyoment_rails.git' # Edit this to match your repository
set :branch, :master
set :deploy_to, '/home/deploy/urlshortner'
set :pty, true
set :linked_files, %w{config/database.yml config/application.yml}
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system public/uploads}
set :keep_releases, 5

set :puma_env, fetch(:rack_env, fetch(:rails_env, 'production'))

namespace :puma do
	desc 'Create Directories for Puma Pids and Socket'
	task :make_dirs do
		on roles(:app) do
			execute "mkdir #{shared_path}/tmp/sockets -p"
			execute "mkdir #{shared_path}/tmp/pids -p"
		end
	end

	# before :start, :make_dirs
end

namespace :deploy do
	# after :finishing, 'deploy:cleanup'
	# after 'deploy:publishing', 'deploy:restart'
	# after :restart, :clear_cache do
	# 	on roles(:web), in: :groups, limit: 3, wait: 10 do
 #      # Here we can do anything such as:
 #      within release_path do
 #      	execute :rake, 'tmp:clear'
 #      end
 #    end
 #  end

  # desc "Make sure local git is in sync with remote."
  # task :check_revision do
  # 	on roles(:app) do
  # 		unless `git rev-parse HEAD` == `git rev-parse origin/master`
  # 			puts "WARNING: HEAD is not the same as origin/master"
  # 			puts "Run `git push` to sync changes."
  # 			exit
  # 		end
  # 	end
  # end

  desc 'Initial Deploy'
  task :initial do
  	on roles(:app) do
  		before 'deploy:restart', 'puma:start'
  		invoke 'deploy'
  	end
  end

  desc 'Restart application'
  task :restart do
  	on roles(:app), in: :sequence, wait: 5 do
  		invoke 'puma:restart'
  	end
  end

  # before :starting,     :check_revision
  # after  :finishing,    :compile_assets
  # after  :finishing,    :cleanup
  # after  :finishing,    :restart

end

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, "/var/www/my_app_name"

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# append :linked_files, "config/database.yml", "config/secrets.yml"

# Default value for linked_dirs is []
# append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system"

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

# Default value for keep_releases is 5
# set :keep_releases, 5

# Uncomment the following to require manually verifying the host key before first deploy.
# set :ssh_options, verify_host_key: :secure
