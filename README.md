Macros4Cuke
===========

## Add "macros" to your Cucumber feature files. ##
[Homepage](https://github.com/famished-tiger/Macros4Cuke)

## What is it? ##
Macros4Cuke gives you to ability to define a new Cucumber (macro-)step directly in a feature file
 and to associate with it a sequence of steps to execute when the macro-step in used in 
 a scenario.

## How can create such a macro? ## 
Here follows an example taken from our demo file:

  Given I define the step "When I [enter my userid {{userid}} and password {{password}}]" to mean:
  """
  Given I landed in the homepage
  When I click "Sign in"
  And I fill in "Username" with "{{userid}}"
  And I fill in "Password" with "{{password}}"
  And I click "Submit"
  """
  
That macro step  can be used in a scenario like this:
  When I [enter my userid "jdoe" and password "hello-world"]


See also the working examples in the features folder.


Copyright
---------
Copyright (c) 2013, Dimitri Geshef. See [LICENSE.txt](https://github.com/famished-tiger/Macros4Cuke/blob/master/LICENSE.txt) for details.