source 'https://rubygems.org'

ruby '2.2.3'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0.1'
# Bootstrap framework for HTML styling
gem 'bootstrap-sass'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# Use jquery as the JavaScript library
gem 'jquery-rails'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# For controller respond_with action
gem 'responders'
# Query helper for reports
gem 'datagrid'
# PDF generator for reports
gem 'wicked_pdf', git: "https://github.com/Bonias/wicked_pdf.git"
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc
# Use ActiveModel has_secure_password
gem 'bcrypt'
# Use jQuery's masked input for fields
gem 'maskedinput-rails'
# Use pagination for large record sets
gem 'kaminari'
# Money gem for dealing with money objects
gem 'money-rails'

group :development, :test do
  # Use sqlite3 as the database for Active Record
  gem 'sqlite3'
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
end

group :development do
  gem 'minitest-reporters'
  gem 'mini_backtrace'
  gem 'guard'
  gem 'guard-minitest'  
end

group :production do
  gem 'pg'
  gem 'rails_12factor'
  gem 'puma'
end