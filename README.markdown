# bombshell

Ever wanted to give dudes the ability to explore your library interactively? Like, with a custom IRB-like shell/console?

Really, you did? Weird.

## Simple example

(The source code for this example is in [`doc/pizza`](https://github.com/rossmeissl/bombshell/tree/master/doc/pizza).) 

`pizza/bin/pizza`:

``` ruby
#!/usr/bin/env ruby
$:.unshift(File.dirname(__FILE__) + '/../lib') unless $:.include?(File.dirname(__FILE__) + '/../lib')

require 'rubygems'
require 'pizza'
Bombshell.launch(Pizza::Shell)
```

`pizza/lib/pizza/shell.rb`:

``` ruby
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
```

Let's try it out:

    $ pizza
    pizzabot> order 'large'
    Your pizza has been ordered! Super!
    pizzabot>

If you have Bombshell's source checked out, you can try this at home:

``` console
$ cd doc/pizza
$ ./bin/pizza
```

## Prompts

You set your prompt like this:

``` ruby
    prompt_with 'pizza_bot_loves_you'
```

Or like this:

``` ruby
    prompt_with do
     "pizza_bot / #{Time.now}" # binding is on your shell *class*
    end
```

Or even like this:

``` ruby
    prompt_with do |shell|
     "pizza_bot / #{shell.size}" # the block gets the shell *instance* when it asks for it
    end
```

## Callbacks

You can set callbacks like this:

``` ruby
    before_launch do
     init # binding is on your shell *class*
    end

    before_launch do |size|
     Pizza.default_size = size # the block gets as many command-line parameters as you ask for
    end

    having_launched do
     puts size if size # binding is on your shell *instance*
    end
```

## Subshells

If you dump all of your functionality into one shell, things could get a little messy. That's why we have *subshells*.

(The source code for this example is in [`doc/pizza2`](https://github.com/rossmeissl/bombshell/tree/master/doc/pizza2).) 

`pizza/lib/pizza/shell.rb`:

``` ruby
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
```

`pizza/lib/pizza/shell/order.rb`:

``` ruby
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
```

Let's try it out:

    pizzabot> pizza
    new order> size 'large'
    You got it!
    new order> topping 'pepperoni'
    Added pepperoni
    new order> order
    Coming right up!
    pizzabot>

If you have Bombshell's source checked out, you can try this at home:

``` console
$ cd doc/pizza2
$ ./bin/pizza
```

## Tab completion

It's there. Give it a whirl with TAB.

## To use:

* Create a class for your shell and `include Bombshell::Shell`. You should also set this class to inherit from `Bombshell::Environment` as that will ensure your shell doesn't have any extraneous "commands" (i.e. methods) inherited from Object. (If you'd rather use a different basis--like `CleanSlate`--or `undef` methods yourself, go right ahead.)

* Define your commands as instance methods on this class. There's nothing *too* funny going on here, it's just Ruby.

* Kick off the shell with `Bombshell.launch(YourShellClass)`. It's possible to do this from IRB but it's kind of messy (constant reassignment warnings). Instead, set up a "binary" for yourself like `pizza/bin/pizza` at the top of this file.

## Hints:

* Give your users a `help` command!
* Use subshells for hierarchical interactivity!
* Provide as thin of a wrapper you can above your library! We want to see what's going on!

## Copyright

Copyright (c) 2011 Andy Rossmeissl. See LICENSE.txt for
further details.
