# File: demo01.feature

Feature: Show the use of a basic macro
  As a Cuke user
  So that I enjoy writing scenario.

# The background section is THE good place to define your macros.
# Since the steps from this section are pre-pended to the steps of every scenario (outline),
# the macros will be available to every scenario in the feature file.
Background:
  # The next step creates a macro(-step)
  # The syntax of the new macro-step is specified between the < ... > delimiters.
  # The steps to execute when the macro is used/invoked are listed in the multiline triple quotes arguments.
  Given I define the step <When I [log in]> to mean:
  """
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
Invoked step: ... I landed in the homepage
Invoked step: ... I click "Sign in"
Invoked step: ... I fill in "Username" with "johndoe"
Invoked step: ... I fill in "Password" with "unguessable"
Invoked step: ... I click "Submit"
  """