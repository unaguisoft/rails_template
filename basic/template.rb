#Add the current directoy to the path Thor uses to look up files
#(check Thor notes)

#Thor uses source_paths to look up files that are sent to file-based Thor acitons
#https://github.com/erikhuda/thor/blob/master/lib%2Fthor%2Factions%2Ffile_manipulation.rb
#like copy_file and remove_file.

#We're redefining #source_path so we can add the template dir and copy files from it
#to the application
def source_paths
  Array(super)
  [File.expand_path(File.dirname(__FILE__))]
end


# ---------------------------------------
# ---------------------------------------
# GEMFILE
# ---------------------------------------
remove_file "Gemfile"
run "touch Gemfile"
#be sure to add source at the top of the file
add_source 'https://rubygems.org'
gem 'rails', '>= 5.0.0', '< 5.1'
gem 'puma'
gem 'pg', '~> 0.15'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.2'
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'turbolinks', '~> 5'
gem 'jbuilder', '~> 2.5'
gem 'sdoc', '~> 0.4.0', group: :doc
gem 'draper', '~> 3.0.0.pre1' # Decorators
gem 'kaminari', '~> 0.17.0' # Paginator
gem 'bootstrap-sass', '~> 3.3.6'
gem "font-awesome-rails"
gem 'momentjs-rails', '>= 2.9.0' # Datetimepicker dependency
gem 'bootstrap3-datetimepicker-rails', '~> 4.17.37' # Datetimepicker
gem 'sorcery', '~> 0.9.1'
gem "non-stupid-digest-assets"
gem 'platform-api' # Heroku
gem 'sidekiq'
gem 'sidekiq-status'

gem_group :development, :test do
  gem 'pry' # Debugging
  gem "letter_opener"
  gem 'byebug'
end

gem_group :development do
  gem 'web-console', '~> 3.0'
  gem 'spring'
  gem 'annotate', '~> 2.7', '>= 2.7.1' # Muestra campos de la BD en los modelos
  gem 'hirb', '~> 0.7.3'
end

gem_group :test do
  gem 'minitest-reporters'
  gem 'database_cleaner'
  gem 'rails-controller-testing'
end

gem_group :production do
  gem 'rack-cache', require: 'rack/cache'
end

run 'rbenv local 2.3.0'
run 'bundle install'
# ---------------------------------------


# ---------------------------------------
# Directories
# ---------------------------------------
run "mkdir app/filters"
run "mkdir app/services"
run "mkdir app/decorators"
run "mkdir app/presenters"
# ---------------------------------------



# ---------------------------------------
# VENDOR
# ---------------------------------------
inside 'vendor' do
  directory 'assets' # Copy the entire assets folder
  inside 'assets' do
    inside 'javascripts' do
      run "ln -s ../plugins/ plugins" # Build symbolic links
    end
    inside 'stylesheets' do
      run "ln -s ../plugins/ plugins" # Build symbolic links.
    end
  end
end
# ---------------------------------------



# ---------------------------------------
# APP-ASSETS
# ---------------------------------------
remove_dir 'app/assets'
inside 'app' do
  directory 'assets' # Copy the entire assets folder
end
# ---------------------------------------



# ---------------------------------------
# Sorcery
# ---------------------------------------
after_bundle do
  generate "sorcery:install remember_me reset_password"
  rails_command("db:migrate")
  generate "controller UserSessions new create destroy"
  generate "controller User index new edit create update destroy"
end
# ---------------------------------------



# ---------------------------------------
# ROUTEs
# ---------------------------------------
remove_file 'config/routes.rb'
inside 'config' do
  copy_file 'routes.rb'
end
# ---------------------------------------



# ---------------------------------------
# Generate MainController
# ---------------------------------------
generate(:controller, "main")
route "root 'main#home'"
# ---------------------------------------


# ---------------------------------------
# VIEWS / LAYOUT
# ---------------------------------------
remove_dir 'app/views'
inside 'app' do
  inside 'views' do
    directory 'application'
    directory 'layouts'
    directory 'user_sessions'
    directory 'users'
  end
end
# ---------------------------------------



# ---------------------------------------
# README
# ---------------------------------------
remove_file 'README.rdoc'
# ---------------------------------------



# ---------------------------------------
# Git
# ---------------------------------------
after_bundle do
  git :init
  git flow: 'init -d'
  remove_file '.gitignore'
  copy_file ".gitignore"
  git add: '.'
  git commit: "-a -m 'Initial commit'"
end
# ---------------------------------------
