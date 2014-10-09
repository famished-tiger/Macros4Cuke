# File: demo03.feature

Feature: Define and use a macro taking several arguments
  As a Cuke user
  I want versatile macro-steps that accept more than one data argument
  So that I can use them in varied situations.


Scenario: Defining a macro with multiple arguments
  # The next step creates a macro(-step)double quotes.
  # The steps to execute when the macro is used/invoked are listed in the multiline triple quotes arguments.
  # The macro-step arguments are put between chevrons <...>.
  Given I define the step "* I [enter my userid <userid> and password <password>]" to mean:
  """
  Given I landed in the homepage
  When I click "Sign in"
  And I fill in "Username" with "<userid>"
  And I fill in "Password" with "<password>"
  And I click "Submit"
  """

Scenario: Using the macro with multiple arguments
  # Here the macro is invoked. Actual value for the argument is put between double quotes.
  When I [enter my userid "jdoe" and password "cosmic"]

  # The next step verifies that the steps from the macro were effectively executed.
  Then I expect the following step trace:
  """
  Given I landed in the homepage
  When I click "Sign in"
  And I fill in "Username" with "jdoe"
  And I fill in "Password" with "cosmic"
  And I click "Submit"
  """
  
Scenario Outline: Using the macro in a scenario outline with argument values from example rows
  # Macros work smoothly in scenario outlines.
  # Their argument values can even be initialized from the example rows
  # Here the macro is invoked. It argument values <user_id>, <pwd> comes from example rows below.
  When I [enter my userid "<user_id>" and password "<pwd>"]

  # The next step verifies that the steps from the macro were effectively executed.
  Then I expect the following step trace:
  """
  Given I landed in the homepage
  When I click "Sign in"
  And I fill in "Username" with "<user_id>"
  And I fill in "Password" with "<pwd>"
  And I click "Submit"
  """
  Then I click "Sign out"
  
  Examples:
  |user_id |   pwd   | 
  |james007|goldeneye|
  |ann     |oneemous |
