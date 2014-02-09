# File: demo01.feature

Feature: Define and use a basic macro-step
  As a Cuke user
  I want to create macro-steps that replace repeating lower-level steps
  So that I can write shorter and more readable scenarios.


Scenario: Defining a simple macro-step
  # The next step creates a macro(-step)
  # The syntax of the new macro-step is specified between double quotes.
  # The steps to execute when the macro is used/invoked are listed in the multiline triple quotes arguments.
  Given I define the step "* I [log in]" to mean:
  """
  # Here follows the steps to execute when this macro is called
  Given I landed in the homepage
  When I click "Sign in"
  And I fill in "Username" with "johndoe"
  And I fill in "Password" with "unguessable"
  And I click "Submit"
  """

Scenario: Let's use the macro we created above
  # Here the macro is invoked
  When I [log in]

  # The next step verifies that the steps from the macro were effectively executed.
  Then I expect the following step trace:
  """
  Given I landed in the homepage
  When I click "Sign in"
  And I fill in "Username" with "johndoe"
  And I fill in "Password" with "unguessable"
  And I click "Submit"
  """
