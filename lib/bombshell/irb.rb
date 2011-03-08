# encoding: utf-8

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

