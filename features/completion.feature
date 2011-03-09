Feature: Completion

  In order to expedite my exploration
  As a user of a Bombshell-enabled Ruby library
  I want to be able to use tab completion
  
  Scenario: Single matching command
    Given a file named "fooshell.rb" with:
      """
      require 'bombshell'
      module Foo
        class Shell < Bombshell::Environment
          include Bombshell::Shell
          def abcdef; end
        end
      end
      Bombshell.launch Foo::Shell
      """
    When I run "ruby fooshell.rb" interactively
    And I type "abc" and hit tab
    And I type "quit"
    Then the output should contain:
      """
      abcdef
      """
    And the output should not contain:
      """
      method_missing
      """
      
  Scenario: Multiple matching commands
    Given a file named "fooshell.rb" with:
      """
      require 'bombshell'
      module Foo
        class Shell < Bombshell::Environment
          include Bombshell::Shell
          def abcd; end
          def abcx; end
        end
      end
      Bombshell.launch Foo::Shell
      """
    When I run "ruby fooshell.rb" interactively
    And I type "abc" and hit tab twice
    And I type "quit"
    Then the output should contain:
      """
      abcd
      """
    And the output should contain:
      """
      abcx
      """

