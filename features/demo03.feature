# File: demo03.feature

Feature: Show the use of a basic macro with multiple arguments
  As a Cuke user
  So that I enjoy writing scenario.


Scenario: defining basic macro with multiple arguments
  # The next step creates a macro(-step)double quotes.
  # The steps to execute when the macro is used/invoked are listed in the multiline triple quotes arguments.
  # The macro argument is put between double(triple) curly braces {{...}} as required by the Mustache template library.
  Given I define the step "When I [enter my userid {{userid}} and password {{password}}]" to mean:
  """
  Given I landed in the homepage
  When I click "Sign in"
  And I fill in "Username" with "{{userid}}"
  And I fill in "Password" with "{{password}}"
  And I click "Submit"
  """

Scenario: Let's use the macro we created above
  # Here the macro is invoked. Actual value for the argument is put between double quotes.
  When I [enter my userid "guest" and password "unguessable"]

  # The next step verifies that the steps from the macro were effectively executed.
  Then I expect the following step trace:
  """
Invoked step: ... I landed in the homepage
Invoked step: ... I click "Sign in"
Invoked step: ... I fill in "Username" with "guest"
Invoked step: ... I fill in "Password" with "unguessable"
Invoked step: ... I click "Submit"
  """

Scenario: A macro invoking another macro (YES, it's possible!)
  Given I define the step "When I [enter my credentials]" to mean:
  """
  {{! Notice that the next step is invoking the first macro above}}
  When I [enter my userid "guest" and password "unguessable"]
  """

  # Invoking our lastly-created macro
  When I [enter my credentials]

  # Check that the nested macro still works
  Then I expect the following step trace:
  """
Invoked step: ... I landed in the homepage
Invoked step: ... I click "Sign in"
Invoked step: ... I fill in "Username" with "guest"
Invoked step: ... I fill in "Password" with "unguessable"
Invoked step: ... I click "Submit"
  """