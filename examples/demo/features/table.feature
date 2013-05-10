# File: travelling-demo.feature


Feature: Show how to define & use macro-steps with data table
  As a Cuke user
  So that I enjoy writing scenario.


Scenario: Defining a macro that requires a data table
  # There is a colon : just after the phrase closing ']'. A data table must be used.
  Given I define the step "* I [fill in the form with]:" to mean:
  """
  When I type "<firstname>"
  And I type "<lastname>"
  And I type "<street_address>"
  And I type "<postcode>"
  And I type "<city>"
  And I type "<country>"
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
  Given I define the step "* I [fill in, as a Londonian, the form with]:" to mean:
  """
  When I [fill in the form with]:
  |firstname| <firstname>|
  |lastname | <lastname> |
  |street_address| <street_address>|
  |postcode|<postcode> |
  # The next two lines have hard-coded values
  |city    |London   |  
  |country | U.K.    |
  """
  
  # Let's try...
  When I [fill in, as a Londonian, the form with]:
  |firstname| Prime|
  |lastname | Minister  |
  |street_address| 10, Downing Street|


