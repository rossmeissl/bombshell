require 'bombshell/shell/commands'

module Bombshell
  module Shell
    def self.included(base)
      base.extend ClassMethods
      base.instance_variable_set :@bombshell_callbacks, :before_launch => [], :having_launched => []
    end
    
    def to_s
      _prompt
    end
    
    include Commands
    
    def _prompt
      if self.class.bombshell_prompt.is_a? String
        self.class.bombshell_prompt
      elsif self.class.bombshell_prompt.is_a? Proc and self.class.bombshell_prompt.arity == 1
        self.class.bombshell_prompt.call self
      elsif self.class.bombshell_prompt.is_a? Proc
        self.class.bombshell_prompt.call
      else
        '[Bombshell]'
      end
    end
    
    def get_binding
      binding
    end
    
    module ClassMethods
      def launch(*arguments)
        @bombshell_callbacks[:before_launch].each do |callback|
          callback.call(*arguments.first(callback.arity > -1 ? callback.arity : 0))
        end
        shell = new(*arguments)
        @bombshell_callbacks[:having_launched].each do |callback|
          shell.instance_eval &callback
        end
        ::IRB.start_session(shell.get_binding)
      end
    
      def before_launch(&callback)
        @bombshell_callbacks[:before_launch] << callback
      end

      def having_launched(&callback)
        @bombshell_callbacks[:having_launched] << callback
      end
      
      def prompt_with(p = nil, &prompt)
        @bombshell_prompt = p || prompt
      end
      
      def bombshell_prompt
        @bombshell_prompt
      end
    end
  end
end

