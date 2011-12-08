# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "bombshell/version"

Gem::Specification.new do |s|
  s.name = %q{bombshell}
  s.version = Bombshell::VERSION

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Andy Rossmeissl"]
  s.date = "2011-12-08"
  s.description = %q{Give your application or gem an interactive shell, complete with custom prompts, tab completion, and various callbacks. Commands are defined as Ruby methods and can be grouped into logical subshells.}
  s.email = %q{andy@rossmeissl.net}
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.markdown"
  ]
  s.files = [
    "bombshell.gemspec",
    "lib/bombshell.rb",
    "lib/bombshell/completor.rb",
    "lib/bombshell/environment.rb",
    "lib/bombshell/irb.rb",
    "lib/bombshell/version.rb",
    "lib/bombshell/shell.rb",
    "lib/bombshell/shell/commands.rb"
  ]
  s.homepage = %q{http://github.com/rossmeissl/bombshell}
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.6.2}
  s.summary = %q{Custom IRB consoles made easy}
  s.add_development_dependency 'aruba', '>= 0.3.4'
  s.add_development_dependency 'bueller'
end

