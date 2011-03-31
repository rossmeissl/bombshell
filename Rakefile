require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'cucumber/rake/task'
Cucumber::Rake::Task.new
task :default => :cucumber

require 'bueller'
Bueller::Tasks.new
