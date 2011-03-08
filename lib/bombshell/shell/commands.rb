module Bombshell
  module Shell
    module Commands
      HIDE = [:method_missing, :get_binding, :_prompt, :to_s]
      
      def quit
        throw :IRB_EXIT
      end
      def method_missing(*args)
        return if [:extend, :respond_to?].include? args.first
        puts "Unknown command #{args.first}"
      end
    end
  end
end


