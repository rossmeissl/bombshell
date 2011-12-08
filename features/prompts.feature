Feature: Prompts

  In order to brand my custom shell experience
  As a developer of a Bombshell-enabled Ruby library
  I want to set custom prompts
  
  Scenario: Static-string prompt
    Given a file named "fooshell.rb" with:
      """
      require 'bombshell'
      module Foo
        class Shell < Bombshell::Environment
          include Bombshell::Shell
          prompt_with 'fooprompt'
        end
      end
      Bombshell.launch Foo::Shell
      """
    When I run `ruby fooshell.rb` interactively
    And I type "quit"
    Then the output should contain:
      """
      fooprompt>
      """
      
  Scenario: Class-oriented prompt
    Given a file named "fooshell.rb" with:
      """
      require 'bombshell'
      module Foo
        class Shell < Bombshell::Environment
          include Bombshell::Shell
          prompt_with do
            _prompt
          end
          def self._prompt; 'fooprompt-class' end  
        end
      end
      Bombshell.launch Foo::Shell
      """
    When I run `ruby fooshell.rb` interactively
    And I type "quit"
    Then the output should contain:
      """
      fooprompt-class>
      """

  Scenario: Instance-oriented prompt
    Given a file named "fooshell.rb" with:
      """
      require 'bombshell'
      module Foo
        class Shell < Bombshell::Environment
          include Bombshell::Shell
          prompt_with do |foo|
            foo._prompt
          end
          def _prompt; 'fooprompt-instance' end  
        end
      end
      Bombshell.launch Foo::Shell
      """
    When I run `ruby fooshell.rb` interactively
    And I type "quit"
    Then the output should contain:
      """
      fooprompt-instance>
      """

