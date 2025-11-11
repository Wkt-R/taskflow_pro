source "https://rubygems.org"


gem "rails", "~> 8.1.1"
gem "sprockets-rails"
gem "pg", "~> 1.1"
gem "puma", ">= 5.0"
gem "jsbundling-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "cssbundling-rails"
gem "jbuilder"

gem "sidekiq", "~> 7.2"
gem "redis", "~> 5.0"
gem "foreman", "~> 0.89"

gem "devise", "~> 4.9"

gem "bcrypt", "~> 3.1"

gem "letter_opener", group: :development

gem "tzinfo-data", platforms: %i[ windows jruby ]
gem "bootsnap", require: false

group :development, :test do
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"
  gem "brakeman", require: false
  gem "rubocop-rails-omakase", require: false
end

group :development do
  gem "web-console"
  gem "kamal", "~> 1.3"
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
end
