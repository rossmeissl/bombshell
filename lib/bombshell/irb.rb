# encoding: utf-8

# We have to monkey patch a method into IRB here. I've tried extending it, and it doesn't work.
module IRB
  # Launch a custom IRB session with the given binding, set up the prompt, and define tab completion.
  # @param [Binding] binding Your shell's binding
  def self.start_session(binding)
    unless @__initialized
      args = ARGV
      ARGV.replace(ARGV.dup)
      IRB.setup(nil)
      ARGV.replace(args)
      @__initialized = true
    end

    workspace = WorkSpace.new(binding)
    
    @CONF[:PROMPT][:BOMBSHELL] = {
      :PROMPT_I => "%m> ",
      :PROMPT_S => "%m\"> ",
      :PROMPT_C => "%m…>",
      :PROMPT_N => "%m→>",
      :RETURN => ''
    }
    @CONF[:PROMPT_MODE] = :BOMBSHELL

    irb = Irb.new(workspace)

    ::Readline.completion_proc = Bombshell::Completor.new(eval('self.class', binding)).method(:complete)
    
    @CONF[:IRB_RC].call(irb.context) if @CONF[:IRB_RC]
    @CONF[:MAIN_CONTEXT] = irb.context
    catch(:IRB_EXIT) do
      irb.eval_input
    end
  end
end

