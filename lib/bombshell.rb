require 'irb'

require 'bombshell/shell'
require 'bombshell/completor'
require 'bombshell/environment'
require 'bombshell/irb'

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