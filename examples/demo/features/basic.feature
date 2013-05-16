# File: basic.feature

Feature: Show -visually- the several ways to use macros
  As a Cuke user
  So that I enjoy writing scenario.


Scenario: Definition of a silly macro-step without argument
   Given I define the step "* I [bark three times]" to mean:
   """
   When I type "woof!"
   And I type "Woof!"
   And I type "WOOF!"
   """
   
Scenario: Let's bark
	When I [bark three times]
	# You should see woof! three times...
  


Scenario: Definition of a simple macro-step with two arguments
  Given I define the step "* I [travel from <origin> to <destination>]" to mean:
  """
  When I leave '<origin>'
  And I arrive in <destination>
  """

Scenario: Do a simple travel
  # Call a macro-step defined earlier
  When I [travel from "Brussels" to "Rome"]
  # You should see the output:
  # I leave 'Brussels'
  # I arrive in Rome
  
  
  # Actual values can have embedded double quotes provided they are escaped.
  When I [travel from "Tampa" to "\"Little Italy\""]
  # You should see the output:
  # I leave 'Tampa'
  # I arrive in "Little Italy"  
  
  # Actual values MUST be present in the phrase (but they can be empty)
  When I [travel from "" to "North Pole"]
  # You should see the output:
  # I leave ''
  # I arrive in North Pole    



Scenario: Defining a macro that's calling other macro-steps
  Given I define the step "* I [travel from <origin> to <destination> and back]" to mean:
  """
  # The next two steps are, in fact, macro-step invokations
  When I [travel from "<origin>" to "<destination>"]
  When I [travel from "<destination>" to "<origin>"]
  """

Scenario: Do a travel back and forth
    When I [travel from "Paris" to "London" and back]

  # You should see the output:
  # I leave 'Paris'
  # I arrive in London
  # I leave 'London'
  # I arrive in Paris


  # End of file