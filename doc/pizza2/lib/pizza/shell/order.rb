module Pizza
 class Shell
   class Order < Bombshell::Environment
     include Bombshell::Shell
     prompt_with 'new order'

     def size(s)
       @size = s
       puts 'You got it!'
     end

     def topping(t)
       @toppings ||= []
       @toppings << t
       puts "Added #{t}"
     end

     def order
       Pizza::Order.new :size => @size, :toppings => @toppings
       puts 'Coming right up!'
       quit
     end
   end
 end
end
