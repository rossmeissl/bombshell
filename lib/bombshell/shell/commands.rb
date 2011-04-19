module Bombshell
  module Shell
    # Standard commands that show up in all Bombshell shells.
    module Commands
      # An explicit list of commands to hide from tab completion.
      HIDE = [:method_missing, :get_binding, :_prompt, :to_s]
      
      # Exit safely, accounting for the fact that we might be inside a subshell.
      def quit
        throw :IRB_EXIT
      end
      
      # Provide an error message for unknown commands rather than raise an exception.
      def method_missing(*args)
        return if [:extend, :respond_to?].include? args.first
        puts "Unknown command #{args.first}"
      end
    end
  end
end


