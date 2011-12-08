Feature: Custom shell

  In order to allow my users to explore my library
  As a Ruby library developer
  I want to give them an interactive shell
  
  Scenario: Running the shell
    Given a file named "fooshell.rb" with:
      """
      require 'bombshell'
      module Foo
        class Shell < Bombshell::Environment
          include Bombshell::Shell
        end
      end
      Bombshell.launch Foo::Shell
      """
    When I run `ruby fooshell.rb` interactively
    And I type "quit"
    Then the output should contain:
      """
      [Bombshell]
      """
      
  Scenario: Using a command
    Given a file named "fooshell.rb" with:
      """
      require 'bombshell'
      module Foo
        class Shell < Bombshell::Environment
          include Bombshell::Shell
          def hello
            puts 'hello world'
          end
        end
      end
      Bombshell.launch Foo::Shell
      """
    When I run `ruby fooshell.rb` interactively
    And I type "hello"
    And I type "quit"
    Then the output should contain:
      """
      [Bombshell]
      """
