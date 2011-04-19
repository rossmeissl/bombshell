module Bombshell
  # A class used by <tt>IRB.start_session</tt> to handle tab completion.
  class Completor
    # Always initialize Completor with the shell it's completing for.
    def initialize(shell)
      @shell = shell
    end
    
    attr_reader :shell
    
    # Provide completion for a given fragment.
    # @param [String] fragment the fragment to complete for
    def complete(fragment)
      self.class.filter(shell.instance_methods).grep Regexp.new(Regexp.quote(fragment))
    end
    
    # Filter out irrelevant methods that shouldn't appear in a completion list.
    def self.filter(m)
      (m - Bombshell::Environment.instance_methods - Bombshell::Shell::Commands::HIDE).reject do |m|
        m =~ /^_/
      end
    end
  end
end

