# encoding: utf-8

require 'irb'

#in bin/foo:
# Bombshell.launch(Foo::Shell)

#BOMBSHELL
# lib/bombshell/shell/commands.rb
module Bombshell
  module Shell
    module Commands
      HIDE = [:method_missing, :get_binding, :_prompt, :to_s]
      
      def quit
        exit
      end
      def method_missing(*args)
        return if [:extend, :respond_to?].include? args.first
        puts "Unknown command #{args.first}"
      end
    end
  end
end

# lib/bombshell/environment.rb
module Bombshell
  class Environment
    instance_methods.each do |m|
      undef_method m if m.to_s !~ /(?:^__|^nil\?$|^send$|^instance_eval$|^define_method$|^class$|^object_id|^instance_methods$)/
    end
  end
end


# lib/bombshell/shell.rb
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
      def launch(arguments)
        @bombshell_callbacks[:before_launch].each(&:call)
        shell = new
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

# lib/bombshell/interpreter.rb
module IRB
  def self.start_session(binding)
    unless @__initialized
      args = ARGV
      ARGV.replace(ARGV.dup)
      IRB.setup(nil)
      ARGV.replace(args)
      @__initialized = true
    end

    workspace = WorkSpace.new(binding)
    
    @CONF[:PROMPT][:CARBON] = {
      :PROMPT_I => "%m> ",
      :PROMPT_S => "%m\"> ",
      :PROMPT_C => "%m…>",
      :PROMPT_N => "%m→>",
      :RETURN => ''
    }
    @CONF[:PROMPT_MODE] = :CARBON

    irb = Irb.new(workspace)

    ::Readline.completion_proc = Bombshell::Completor.new(eval('self.class', binding)).method(:complete)
    
    @CONF[:IRB_RC].call(irb.context) if @CONF[:IRB_RC]
    @CONF[:MAIN_CONTEXT] = irb.context
    catch(:IRB_EXIT) do
      irb.eval_input
    end
  end
end

# lib/bombshell/completor.rb
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

# lib/bombshell.rb
module Bombshell
  def launch(shell)
    begin
      failure = shell.launch(ARGV.dup)
      Kernel.exit(failure ? 1 : 0)
    rescue SystemExit => e
      Kernel.exit(e.status)
    rescue Exception => e
      STDERR.puts("#{e.message} (#{e.class})")
      STDERR.puts(e.backtrace.join("\n"))
      Kernel.exit(1)
    end
  end
  module_function :launch
end

#FOO, a gem
# lib/foo
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
