# File: demo04.feature

Feature: Show the use of a macro with multiple arguments in a table
  As a Cuke user
  So that I enjoy writing scenario.


Scenario: Defining a macro to be used with multiple arguments in a table
  # The next step creates a macro(-step)
  # The syntax of the new macro-step is specified between double quotes.
  # The steps to execute when the macro is used/invoked are listed in the multiline triple quotes arguments.
  # The macro arguments are put between chevrons <...>.
  Given I define the step "* I [enter my credentials as]:" to mean:
  """
  Given I landed in the homepage
  When I click "Sign in"
  And I fill in "Username" with "<userid>"
  And I fill in "Password" with "<password>"
  And I click "Submit"
  """

Scenario: Let's use the macro we created above
  # Here the macro is invoked. Actual value for the argument are passed in a table argument.
  When I [enter my credentials as]:
  |userid|guest|
  |password|unguessable|

  # The next step verifies that the steps from the macro were effectively executed.
  Then I expect the following step trace:
  """
Invoked step: ... I landed in the homepage
Invoked step: ... I click "Sign in"
Invoked step: ... I fill in "Username" with "guest"
Invoked step: ... I fill in "Password" with "unguessable"
Invoked step: ... I click "Submit"
  """
