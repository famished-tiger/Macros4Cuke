# File: demo02.feature

Feature: Define and use a macro taking one argument
  As a Cuke user
  I want to pass data to macro-steps
  So that I can use them in more varied situations.
  


Scenario: Defining a macro-step with one argument (userid)
  # The next step creates a macro(-step)
  # The syntax of the new macro-step to create is specified between the double quotes.
  # The steps to execute when the macro is used/invoked are listed in the multiline triple quotes arguments.
  # The macro argument is put between chevrons <...>.
  Given I define the step "* I [log in as <userid>]" to mean:
  """
  Given I landed in the homepage
  When I click "Sign in"
  # The next step uses the macro-step argument <userid>
  And I fill in "Username" with "<userid>"
  And I fill in "Password" with "unguessable"
  And I click "Submit"
  """

Scenario: Use the macro created above pass it a user id
  # Here the macro is invoked. Actual value for the argument is put between double quotes.
  When I [log in as "guest"]

  # The next step verifies that the steps from the macro were effectively executed.
  Then I expect the following step trace:
  """
Invoked step: ... I landed in the homepage
Invoked step: ... I click "Sign in"
Invoked step: ... I fill in "Username" with "guest"
Invoked step: ... I fill in "Password" with "unguessable"
Invoked step: ... I click "Submit"
  """
  
  
Scenario: Use the macro with another user id
  When I [log in as "me-again"]

  # The next step verifies that the steps from the macro were effectively executed.
  Then I expect the following step trace:
  """
Invoked step: ... I landed in the homepage
Invoked step: ... I click "Sign in"
Invoked step: ... I fill in "Username" with "me-again"
Invoked step: ... I fill in "Password" with "unguessable"
Invoked step: ... I click "Submit"
  """
