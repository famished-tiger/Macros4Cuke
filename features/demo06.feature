# File: demo06.feature

Feature: Show how to define conditional substeps in a macro-step.
  As a Cuke user
  So that I enjoy writing scenario.


Scenario: Defining a macro with conditional substeps
  Given I define the step "* I [fill in the form with]:" to mean:
  """
  When I fill in "first_name" with "<firstname>"
  And I fill in "last_name" with "<lastname>"
  And I fill in "street_address" with "<street_address>"
  And I fill in "zip" with "<postcode>"
  And I fill in "city" with "<city>"
  And I fill in "country" with "<country>"
  
  # Let's assume that the e-mail field is optional.
  # The step between the <?email>...<email> will be executed
  # when the argument <email> has a value assigned to it.
  <?email>
  And I fill in "email" with "<email>"
  </email>
  
  # Let's also assume that comment is also optional
  # See the slightly different syntax: the conditional section
  # <?comment>...<comment> may fit in a single line
<?comment>  And I fill in "comment" with "<comment>"</comment>
  And I click "Save"
  """
  

Scenario: An exception is forced by invoking the above macro with a triple quote string instead of a data table.
  When I generate a DataTableNotFound exception  

  
Scenario: Let's use the macro-step WITHOUT the optional argument values.
  When I [fill in the form with]:
  |firstname|Alice|
  |lastname| Inn |
  |street_address| 11, No Street|
  |city| Nowhere-City|
  |country|Wonderland|
  # No e-mail
  # No comment

  # The next step verifies that the optional steps from the macro were ignored.
  Then I expect the following step trace:
  """
  Invoked step: ... I fill in "first_name" with "Alice"
  Invoked step: ... I fill in "last_name" with "Inn"
  Invoked step: ... I fill in "street_address" with "11, No Street"
  Invoked step: ... I fill in "zip" with ""
  Invoked step: ... I fill in "city" with "Nowhere-City"
  Invoked step: ... I fill in "country" with "Wonderland"
  Invoked step: ... I click "Save"
  """
  
  
Scenario: Let's use the macro-step WITH the optional argument values.  
  # Redo, now with e-mail and comment
  When I [fill in the form with]:
  |firstname|Alice|
  |lastname| Inn |
  |street_address| 11, No Street|
  |city| Nowhere-City|
  |country|Wonderland|
  # Here come the optional values
  |email|alice.inn@wonder.land|
  |comment|No comment!|

  # The next step verifies that the optional steps from the macro were ignored.
  Then I expect the following step trace:
  """
  Invoked step: ... I fill in "first_name" with "Alice"
  Invoked step: ... I fill in "last_name" with "Inn"
  Invoked step: ... I fill in "street_address" with "11, No Street"
  Invoked step: ... I fill in "zip" with ""
  Invoked step: ... I fill in "city" with "Nowhere-City"
  Invoked step: ... I fill in "country" with "Wonderland"
  Invoked step: ... I fill in "email" with "alice.inn@wonder.land"
  Invoked step: ... I fill in "comment" with "No comment!"
  Invoked step: ... I click "Save"
  """
  
