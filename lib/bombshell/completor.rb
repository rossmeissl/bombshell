module Bombshell
  class Completor
    def initialize(shell)
      @shell = shell
    end
    
    attr_reader :shell
    
    def complete(fragment)
      self.class.filter(shell.instance_methods).grep Regexp.new(Regexp.quote(fragment))
    end
    
    def self.filter(m)
      m - Bombshell::Environment.instance_methods - Bombshell::Shell::Commands::HIDE
    end
  end
end

