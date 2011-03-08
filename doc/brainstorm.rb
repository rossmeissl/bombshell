$:.push File.join(File.dirname(__FILE__), '..', 'lib')
require 'bombshell'

module Foo
  class Shell < Bombshell::Environment
    include Bombshell::Shell
    
    before_launch do
      @punctuation = '!'
    end
    
    before_launch do |arg|
      puts arg if arg
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
    
    def sub
      Subshell.launch
    end
    
    class << self
      def punctuation
        @punctuation
      end
    end
  end
end

module Foo
  class Subshell < Bombshell::Environment
    include Bombshell::Shell
    
    def do_something_else
      puts '... and done'
    end
    
    prompt_with '[foo::subshell]'
  end
end

Bombshell.launch(Foo::Shell)
