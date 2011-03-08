Feature: Subshells

  In order to organize my shell commands
  As a developer of a Bombshell-enabled Ruby library
  I want to use subshells
  
  Scenario: Using subshells
    Given a file named "fooshell.rb" with:
      """
      require 'bombshell'
      module Foo
        class Shell < Bombshell::Environment
          include Bombshell::Shell
          def deeper
            Subshell.launch
          end
          prompt_with 'first'
          class Subshell < Bombshell::Environment
            include Bombshell::Shell
            def foo; puts 'bar' end
            prompt_with 'second'
          end
        end
      end
      Bombshell.launch Foo::Shell
      """
    When I run "ruby fooshell.rb" interactively
    And I type "deeper"
    And I type "foo"
    And I type "quit"
    And I type "quit"
    Then the output should contain:
      """
      first> deeper
      """
    And the output should contain:
      """
      second> foo
      bar
      """
    And the output should contain:
      """
      second> quit
      """
    And the output should contain:
      """
      first> quit
      """
