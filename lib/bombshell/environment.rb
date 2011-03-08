module Bombshell
  class Environment
    instance_methods.each do |m|
      undef_method m if m.to_s !~ /(?:^__|^nil\?$|^send$|^instance_eval$|^define_method$|^class$|^object_id|^instance_methods$)/
    end
  end
end

