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
Invoked step: ... I landed in the homepage
Invoked step: ... I click "Sign in"
Invoked step: ... I fill in "Username" with "jdoe"
Invoked step: ... I fill in "Password" with "cosmic"
Invoked step: ... I click "Submit"
  """

