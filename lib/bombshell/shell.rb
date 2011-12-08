require 'bombshell/shell/commands'

module Bombshell
  # Classes include this module to become Bombshell shells.
  module Shell
    # Add class methods and a callback hash to your shell.
    def self.included(base)
      base.extend ClassMethods
      base.instance_variable_set :@bombshell_callbacks, :before_launch => [], :having_launched => []
    end
    
    # IRB has pretty limited hooks for defining prompts, so we have to piggyback on your
    # shell's <tt>#to_s</tt>. Hope you don't need it for something else.
    def to_s
      _prompt
    end
    
    include Commands
    
    # Render and return your shell's prompt.
    #
    # You can define the prompt with <tt>MyShell.prompt_with</tt> and access it without rendering with <tt>MyShell.bombshell_prompt</tt>.
    # @see ClassMethods#prompt_with
    # @see ClassMethods#bombshell_prompt
    # @return String
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
    
    # Returns your shell's binding, which IRB needs (desperately).
    # @return Binding
    def get_binding
      binding
    end
    
    # Class methods for your shell
    module ClassMethods
      # Launch the shell.
      #
      # You should generally call <tt>Bombshell.launch(MyShell)</tt> instead
      # of <tt>MyShell.launch</tt> directly, as the former approach will handle
      # exits correctly and pass command-line parameters as arguments.
      # @param [Array] arguments An array of arguments that, eventually, callbacks
      #   might use. If you're using the <tt>Bombshell.launch</tt> wrapper, these
      #   will be command-line parameters.
      def launch(*arguments)
        @bombshell_callbacks[:before_launch].each do |callback|
          callback.call(*arguments.first(callback.arity > -1 ? callback.arity : 0))
        end
        number_of_requested_arguments = instance_method(:initialize).arity < 0 ? arguments.length : instance_method(:initialize).arity
        shell = new(*arguments.first(number_of_requested_arguments))
        @bombshell_callbacks[:having_launched].each do |callback|
          shell.instance_eval &callback
        end
        ::IRB.start_session(shell.get_binding)
      end
    
      # Define a callback that will get called before your shell is instantiated (and
      # therefore before it is handed over to IRB).
      # 
      # This is a great place to
      # dynamically define additional instance methods on your class. If your callback
      # proc asks for blockvars, Bombshell will give it as many command-line parameters
      # as it needs to. Within the callback, <tt>self</tt> is your shell <i>class</i>.
      # @see #having_launched
      # @example
      #   class MyShell < Bombshell::Environment
      #     include Bombshell::Shell
      #     before_launch do
      #       define_method :foo
      #         puts 'bar'
      #       end
      #     end
      #   end
      # @example
      #   class MyShell < Bombshell::Environment
      #     include Bombshell::Shell
      #     before_launch do |first_command_line_parameter, second_command_line_parameter|
      #       define_method :display_first_command_line_parameter
      #         puts first_command_line_parameter
      #       end
      #     end
      #   end
      def before_launch(&callback)
        @bombshell_callbacks[:before_launch] << callback
      end

      # Define a callback that will get called <i>after</i> your shell is instantiated,
      # but <i>before</i> its binding is handed over to IRB.  Within the callback, <tt>self</tt> is your shell <i>instance</i>.
      # @see #before_launch
      def having_launched(&callback)
        @bombshell_callbacks[:having_launched] << callback
      end
      
      # Define your shell's prompt.
      #
      # You can either set your prompt to a static string, or use a Proc for a dynamic prompt.
      # @param [String] p a string to be used as your shell's prompt.
      # @param [Proc] prompt a Proc to be rendered whenever your shell's prompt needs to be
      #   displayed.  Within the callback, <tt>self</tt> is your shell <i>class</i>. If your
      #   proc asks for a blockvar, it will be given your shell <i>instance</i>.
      # @see Bombshell::Shell#_prompt
      # @see #bombshell_prompt
      def prompt_with(p = nil, &prompt)
        @bombshell_prompt = p || prompt
      end
      
      # Read your shell's prompt
      #
      # Note that this method returns an <i>unrendered</i> prompt. That is, if it's defined as
      # a Proc, you'll get a Proc back. If you want to get the rendered prompt, use <tt>#_prompt</tt>
      # on your shell instance.
      # @see #prompt_with
      # @see Bombshell::Shell#_prompt
      def bombshell_prompt
        @bombshell_prompt
      end
    end
  end
end

