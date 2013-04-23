Macros4Cuke
===========

_Add macros to your Cucumber scenarios._  
[Homepage](https://github.com/famished-tiger/Macros4Cuke)

__Macros4Cuke__ gives you the opportunity to factor out repeated steps
 in your Cucumber scenarios. You can create (macro-)steps directly in feature files.   
To each macro-step, it is possible to associate a sequence of sub-steps
 that will be executed every time a macro-step occurs in a scenario.

### Highlights ###
* Works with out-of-the-box Cucumber
* Simple installation and setup (no programming required),
* Substep sequence can be of arbitrary length,
* Macro-steps may have data arguments,
* Data values can be passed to the sub-steps.

## Synopsis ##
Here is an example taken from our demo files:  
```cucumber
  Given I define the step "When I [enter my userid {{userid}} and password {{password}}]" to mean:  
  """  
  Given I landed in the homepage  
  When I click "Sign in"  
  And I fill in "Username" with "{{userid}}"  
  And I fill in "Password" with "{{password}}"  
  And I click "Submit"  
  """  
```

Notice how the arguments are enclosed between curly braces {{..}}. In its current incarnation,
Macros4Cuke relies on the [Mustache](http://mustache.github.io/mustache.5.html) template engine
 for generating the sub-steps.

That macro-step can then be used in a scenario like this:  
```cucumber
  When I [enter my userid "jdoe" and password "hello-world"]
```

See also the working examples in the features folder.

### Install and setup ###
* Step 1: Install the macros4cuke gem:
```bash  
gem install macros4cuke
```

  
* Step 2: Add support for macros in your Cucumber project  
In your /features/support/ folder:    
  - Create a Ruby file (e.g. 'macro\_support.rb') with the following contents:  
```ruby
require 'macros4cuke'  
World(Macros4Cuke::MacroStepSupport)
```  
  
* Step 3: Import the macro-management steps  
In your /features/step_definitions/ folder:  
  - Create a ruby file (say, 'use\_macro\_steps.rb') with the following line:  
```ruby  
require 'macros4cuke/../macro_steps'
```  
  
Now, you can start writing macros in your Cucumber project.


Copyright
---------
Copyright (c) 2013, Dimitri Geshef. See [LICENSE.txt](https://github.com/famished-tiger/Macros4Cuke/blob/master/LICENSE.txt) for details.