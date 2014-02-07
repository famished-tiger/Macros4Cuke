# File: demo06.feature

Feature: Show the use of a macro with multiple arguments in a table
  As a Cuke user
  So that I enjoy writing scenario.


Scenario: Defining a macro to be used with multiple arguments in a table
  # The next step creates a macro(-step)
  # The syntax of the new macro-step is specified between double quotes.
  # The steps to execute when the macro is used/invoked are listed in the multiline triple quotes arguments.
  # The macro arguments are put between chevrons <...>.
  Given I define the step "* I [enter my profile as]:" to mean:
  """ 
  And I fill in "location" with "<location>"
  And I fill in "email" with "<email>"
  And I fill in "comment" with "<comment>"
  And I click "Save"
  """

Scenario: Let's use the macro we created above
  # Here the macro is invoked. Actual value for the argument are passed in a table argument.
  When I [enter my profile as]:
  |location|Nowhere-City|
  |email|nobody@example.com|
  |comment|First comment line|
  |comment|Second comment line|
  |comment|Third comment line|

  # The next step verifies that the steps from the macro were effectively executed.
  Then I expect the following step trace:
  """
  Invoked step: ... I fill in "location" with "Nowhere-City"
  Invoked step: ... I fill in "email" with "nobody@example.com"
  Invoked step: ... I fill in "comment" with "First comment line<br/>Second comment line<br/>Third comment line"
  Invoked step: ... I click "Save"
  """
