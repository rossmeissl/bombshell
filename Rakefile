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

require 'jeweler'
Jeweler::Tasks.new do |gem|
  gem.name = "bombshell"
  gem.homepage = "http://github.com/rossmeissl/bombshell"
  gem.license = "MIT"
  gem.summary = %Q{Custom IRB consoles made easy}
  gem.description = %Q{Give your application or gem an interactive shell, complete with custom prompts, tab completion, and various callbacks. Commands are defined as Ruby methods and can be grouped into logical subshells.}
  gem.email = "andy@rossmeissl.net"
  gem.authors = ["Andy Rossmeissl"]
  gem.add_development_dependency 'aruba', '~> 0.3.2'
end
Jeweler::RubygemsDotOrgTasks.new

require 'cucumber/rake/task'
Cucumber::Rake::Task.new
task :default => :cucumber
