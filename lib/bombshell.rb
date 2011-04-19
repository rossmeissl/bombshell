require 'irb'

require 'bombshell/shell'
require 'bombshell/completor'
require 'bombshell/environment'
require 'bombshell/irb'

# Bombshell enables the lickety-split creation of interactive consoles
# (really just boring old custom IRB sessions).
# As a Ruby library developer, you may want to build a little shell into
# your library so that other developers can play around with it before
# adding it to their applications. In the past this has been a real PITA.
# With Bombshell it's a little easier.
module Bombshell
  # Launch a shell. This is typically called from a "gem binary" executable Ruby script as described in the README.
  # @param [Class] shell The shell class to launch. Must include <tt>Bombshell::Shell</tt>.
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