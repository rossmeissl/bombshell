require 'bombshell'

module Pizza
 class Shell < Bombshell::Environment
   include Bombshell::Shell
   prompt_with 'pizzabot'

   def pizza
     Order.launch
   end
 end
end

require 'pizza/shell/order'
