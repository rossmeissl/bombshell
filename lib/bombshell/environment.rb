module Bombshell
  # A (mostly) blank class like Ruby's own CleanSlate. We leave a few important methods in here; your shell shouldn't redefine them.
  # It's best practice to set your shell classes to inherit from <tt>Bombshell::Environment</tt>. See the README for more details.
  # @see file:README.markdown
  class Environment
    instance_methods.each do |m|
      undef_method m if m.to_s !~ /(?:^__|^nil\?$|^send$|^instance_eval$|^define_method$|^class$|^object_id|^instance_methods$)/
    end
  end
end

