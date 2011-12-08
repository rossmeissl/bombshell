Feature: Callbacks

  In order to have customization flexibility
  As a Ruby library developer
  I want to have access to callbacks
  
  Scenario: Using a before_launch callback
    Given a file named "fooshell.rb" with:
      """
      require 'bombshell'
      module Foo
        class Shell < Bombshell::Environment
          include Bombshell::Shell
          before_launch do
            puts "Hi, I'm #{name}"
          end
          def self.name; 'Foo' end
        end
      end
      Bombshell.launch Foo::Shell
      """
    When I run `ruby fooshell.rb` interactively
    And I type "quit"
    Then the output should contain:
      """
      Hi, I'm Foo
      """
      
  Scenario: Using a having_launched callback
    Given a file named "fooshell.rb" with:
      """
      require 'bombshell'
      module Foo
        class Shell < Bombshell::Environment
          include Bombshell::Shell
          having_launched do
            puts "Hi, I'm an instance of #{self.class}"
          end
        end
      end
      Bombshell.launch Foo::Shell
      """
    When I run `ruby fooshell.rb` interactively
    And I type "quit"
    Then the output should contain:
      """
      Hi, I'm an instance of Foo::Shell
      """
