# File: demo02.feature

Feature: Show the use of a basic macro with one argument
  As a Cuke user
  So that I enjoy writing scenario.


Scenario: Creating a basic scenario with one argument
  # The next step creates a macro(-step)
  # The syntax of the new macro-step is specified between the double quotes.
  # The steps to execute when the macro is used/invoked are listed in the multiline triple quotes arguments.
  # The macro argument is put between chevrons <...>.
  Given I define the step "* I [log in\[\] as <userid>]" to mean:
  """
  Given I landed in the homepage
  When I click "Sign in"
  And I fill in "Username" with "<userid>"
  And I fill in "Password" with "unguessable"
  And I click "Submit"
  """

Scenario: Let's use the macro we created above
  # Here the macro is invoked. Actual value for the argument is put between double quotes.
  When I [log in\[\] as "guest"]

  # The next step verifies that the steps from the macro were effectively executed.
  Then I expect the following step trace:
  """
Invoked step: ... I landed in the homepage
Invoked step: ... I click "Sign in"
Invoked step: ... I fill in "Username" with "guest"
Invoked step: ... I fill in "Password" with "unguessable"
Invoked step: ... I click "Submit"
  """
