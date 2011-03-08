$:.push File.join(File.dirname(__FILE__), '..', 'lib')
require 'bombshell'

module Foo
  class Shell < Bombshell::Environment
    include Bombshell::Shell
    
    before_launch do
      @punctuation = '!'
    end
    
    having_launched do
      @msg = 'Done' + self.class.punctuation
    end
    
    having_launched do
      puts 'Welcome to FooShell'
    end
    
    prompt_with '==='
    
    def do_something
      puts @msg
    end
    
    class << self
      def punctuation
        @punctuation
      end
    end
  end
end

Bombshell.launch(Foo::Shell)
