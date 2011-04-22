require 'bombshell'

module Pizza
 class Shell < Bombshell::Environment
   include Bombshell::Shell

   prompt_with 'pizzabot'

   def order(size)
     Pizza::Order.new(:size => size).place!
     puts 'Your pizza has been ordered! Super!'
   end
 end
end
