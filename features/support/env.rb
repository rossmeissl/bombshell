$LOAD_PATH.unshift(File.dirname(__FILE__) + '/../../lib')
require 'aruba/cucumber'
require 'fileutils'
require 'rspec/expectations'
require 'bombshell'

Before do
  @aruba_io_wait_seconds = 2
  @dirs = [File.join(ENV['HOME'], 'bombshell_features')]
end
