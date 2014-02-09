# File: demo07.feature

Feature: Insert a call to existing macro-step inside a new macro
  As a Cuke user
  I want to be able to use a macro-step inside higher-level macro-steps
  So that I can use a macro-step to execute complex step sequences
  
  
Scenario: Create a macro that uses another, existing, macro (YES, it's possible!)
  Given I define the step "* I [enter my credentials]" to mean:
  """
  # The next step invokes a macro-step defined elsewhere
  When I [enter my userid "guest" and password "unguessable"]
  """
  
Scenario: Invoking the coarse-grained macro

  # Invoking our lastly-created macro
  When I [enter my credentials]

  # Check that the nested macro still works
  Then I expect the following step trace:
  """
  When I [enter my userid "guest" and password "unguessable"]
  Given I landed in the homepage
  When I click "Sign in"
  And I fill in "Username" with "guest"
  And I fill in "Password" with "unguessable"
  And I click "Submit"
  """