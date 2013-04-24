# File: travelling-demo.feature

Feature: Show -visually- the several ways to use macros
  As a Cuke user
  So that I enjoy writing scenario.


Scenario: Definition of a simple macro-step with two arguments
  Given I define the step "When I [travel from {{origin}} to {{destination}}]" to mean:
  """
  When I leave {{origin}}
  And I arrive in {{destination}}
  """

Scenario: Do a simple travel
  # Call a macro-step defined earlier
  When I [travel from "Brussels" to "Rome"]

  # You should see the output:
  # I leave Brussels
  # I arrive in Rome
  
  # Actual values can have embedded double quotes provided they are escaped.
  When I [travel from "Tampa" to "\"Little Italy\""]  
  
  # Notice the HTML-escaping done by Mustache



Scenario: Defining a macro calling other macro(s)
  Given I define the step "When I [travel from {{origin}} to {{destination}} and back]" to mean:
  """
  # The next two steps are, in fact, macro-step invokations
  When I [travel from "{{origin}}" to "{{destination}}"]
  When I [travel from "{{destination}}" to "{{origin}}"]
  """

Scenario: Do a travel back and forth
    When I [travel from "Paris" to "London" and back]

  # You should see the output:
  # I leave Paris
  # I arrive in London
  # I leave London
  # I arrive in Paris


Scenario: Defining a macro that requires a data table
  Given I define the step "When I [fill in the form with]:" to mean:
  """
  When I type "{{firstname}}"
  And I type "{{lastname}}"
  And I type "{{street_address}}"
  And I type "{{postcode}}"
  And I type "{{city}}"
  And I type "{{country}}"
  """

Scenario: Using a macro-step with a data table
  When I [fill in the form with]:
  |firstname| Sherlock|
  |lastname | Holmes  |
  |street_address| 221B, Baker Street|
  |city    |London   |
  |postcode|NW1 6XE  |
  |country | U.K.    |

  # You should see the output:
  # Sherlock
  # Holmes
  # 221B, Baker Street
  # London
  # U.K.
  
  
  When I [fill in the form with]:
  |firstname| Albert  |
  |lastname | Einstein|
  |street_address| 22, Mercer Street|
  |city   |Princeton|  
  |country| U.S.A   |
  
  # You should see the output:  
  # Albert
  # Einstein
  # 22, Mercer Street

  # Princeton
  # U.S.A

  # Did you notice the empty line in the previous output.
  # Guess what? We forgot to specify a value for the postcode argument.
  
  
Scenario: Demonstrate that it is possible to use a sub-step with a data table
  Given I define the step "When I [fill in, as a Londonian, the form with]:" to mean:
  """
  When I [fill in the form with]:
  |firstname| {{firstname}}|
  |lastname | {{lastname}} |
  |street_address| {{street_address}}|
  |postcode|{{postcode}} |
  # The next two lines have hard-coded values
  |city    |London   |  
  |country | U.K.    |
  """
  
  # Let's try...
  When I [fill in, as a Londonian, the form with]:
  |firstname| Prime|
  |lastname | Minister  |
  |street_address| 10, Downing Street|


