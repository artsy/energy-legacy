source "https://rubygems.org"

gem "xcpretty" # Readable CI
gem "second_curtain" # Snapshot uploads

gem "sbconstants" # Storyboards
gem "danger" # PR Linting

gem "cocoapods" # Deps
gem "cocoapods-keys" # Keys
gem 'cocoapods-check',  git: 'https://github.com/square/cocoapods-check.git' # Don't use CP if cached

gem 'psych' # So our Podfile.lock is consistent

group :deployment do
  gem "fastlane" # Uploading app
  # Fastlane plugins (sentry)
  plugins_path = File.join(File.dirname(__FILE__), 'fastlane', 'Pluginfile')
  eval_gemfile(plugins_path) if File.exist?(plugins_path)
end
