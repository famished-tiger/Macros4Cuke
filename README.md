Macros4Cuke
===========

## Add macros to your Cucumber feature files. ##
[Homepage](https://github.com/famished-tiger/Macros4Cuke)

## What is it? ##
Macros4Cuke gives you to ability to define a new Cucumber (macro-)step directly in a feature file
 and to associate with it a sequence of steps to execute when the macro-step is used in 
 a scenario.

## How can create such a macro? ##
Here follows an example taken from our demo files:

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


## What do I need to start? ##
* Install the macros4cuke gem:
  - gem install macros4cuke
  
* In your 'env.rb' file  
  - 1. Load the modules and classes from the gem:  
  require 'macros4cuke'
  
  
  - 2. Extend the world object like this:  
  World(Macros4Cuke::MacroStepSupport)
  
  
* In your 'step_definitions' folder
  - 3. Import the macro-management steps.  
  Create a ruby file (say, 'use_macro_steps.rb').  
  Add the following line:  
  require 'macros4cuke/../macro_steps'
  
  Your can start writing macros in your Cucumber project.


Copyright
---------
Copyright (c) 2013, Dimitri Geshef. See [LICENSE.txt](https://github.com/famished-tiger/Macros4Cuke/blob/master/LICENSE.txt) for details.