Macros4Cuke
===========

_Add macros to your Cucumber scenarios._  
[Homepage](https://github.com/famished-tiger/Macros4Cuke)

__Macros4Cuke__ is a lightweight library that adds a macro facility your Cucumber scenarios.  
  With it, you can create any new step that replaces a sequence of lower-level steps.
  All this can be done directly in your feature files without programming step definitions.
 
### Highlights ###
* Works with out-of-the-box Cucumber
* Simple installation and setup (no programming required),
* Substep sequence can be of arbitrary length,
* Macro-steps may have data arguments,
* Data values can be passed to the sub-steps.

## A quick example ##
Here is a macro-step example taken from our demo files:  
```cucumber
  Given I define the step "When I [enter my userid <userid> and password <password>]" to mean:  
  """  
  Given I landed in the homepage  
  When I click "Sign in"  
  And I fill in "Username" with "<userid>"  
  And I fill in "Password" with "<password>"  
  And I click "Submit"  
  """  
```

Notice how the arguments _userid_ and _password_ are enclosed between chevrons (angle brackets) <...>.


That macro-step can then be used in a scenario like this:  
```cucumber 
  When I [enter my userid "jdoe" and password "hello-world"]
```

Once it is executing, the macro-step as the same effect as:  
```cucumber 
  Given I landed in the homepage  
  When I click "Sign in"  
  And I fill in "Username" with "jdoe"  
  And I fill in "Password" with "hello-world"  
  And I click "Submit"  
  """  
```

In other words, this sequence of 5 steps can be replaced by just one.
Macros4Cuke not only helps in getting rid of the repeated step sequences,
 it allows the feature writers to create themselves higher-level steps
 that are closer to the business logic.  

See also the working examples in the ```features/``` folder.

## Setup ##
### Installation ###
To install the macros4cuke gem:
```bash  
$[sudo] gem install macros4cuke
```

### Setting up your Cucumber project ####
  
* Step 1: Add support for macros in your Cucumber project  
In your `/features/support/` folder:    
  - Create a Ruby file (e.g. 'macro\_support.rb') with the following contents:  
  
```ruby
require 'macros4cuke'  
World(Macros4Cuke::MacroStepSupport)
```  
  
* Step 2: Import the macro-management steps  
In your `/features/step_definitions/` folder:  
  - Create a Ruby file (say, 'use\_macro\_steps.rb') with the following line:  
  
```ruby  
require 'macros4cuke/../macro_steps'
```  
  
That's it! Now you can start writing macros in your Cucumber project.


## Getting started ##
Working with a macro-step is a two-stages process:  
1. Defining a new macro-step; and,  
2. Using that macro-step in a scenario.

Let's begin by taking a closer look at the definition part.
### Defining a macro-step ###
To create a macro-step, you'll need to use a _defining_ step bundled with Macros4Cuke.
It is a rather unusual Cucumber step in the sense that its sole purpose is to build another step!  
The defining step follows the general pattern:
```cucumber
  Given I define the step "When I [some phrase]" to mean:  
  """  
  # A sequence of sub-steps comes here
  """  
```

The defining step has two key components:  
1. The _quoted sentence_ ```"When I [some phrase]"```. That part
 specifies the syntax of your future macro-step.  
2. The multiline text enclosed between the triple quotes (""") that immediately follows the
 the defining step. It is the place where the sub-steps are listed.  

These two components are detailed now.


#### Specifying the syntax of a macro-step ####
As just mentioned earlier, the __quoted sentence__ determines the syntax of the new macro-step.
Its syntax is more or less free:  
- The text outside the square brackets follows a fixed pattern. In other words,
 the quoted sentence MUST always start as follows: ```"When I [...```. Notice however,
 that the Given, Then keywords are also allowed.  
- The text delimited by the square brackets [...], is called the __phrase__.  

A few remarks about the __phrase__ part:  
- It must be unique. In other words, it is not possible to create another
  macro-step with the same phrase. In fact, Macros4Cuke uses the phrase internally as a mean to identify/name
  a macro-step.  
- It may have one or more arguments.
Besides that, the text inside the phrase can be arbitrary (well, almost).

A phrase can be without argument as in:  
```cucumber
  # A phrase without argument
  [enter my credentials]
```
  
Alternatively, a phrase can have one or more arguments enclosed between chevrons <...>.
For instance, the next first phrase has two arguments, the second has three arguments:  
```cucumber
  [enter my <userid> and <password>]
  [travel from <origin> to <destination> via <waypoint>]
```

Each argument (variable) is enclosed between <...> chevrons. In our last example,
the argument names are: _origin_ and _destination_. Notice that _origin_ and _destination_ are
 variable names that will take a value (if any) when the step is invoked _(more on this later)_.
 

#### Specifying the sub-steps of a macro-step ####
The sub-steps are placed in a Gherkin multiline text, that is, a text that is enclosed between 
 triple quotes ("""). In the next example,  
```cucumber 
  Given I define the step "When I [enter my credentials]" to mean:  
  """  
  Given I landed in the homepage   
  And I fill in "Username" with "tweedledum"  
  And I fill in "Password" with "tweedledee"  
  And I click "Sign in"  
  """  
```  
  
the text between triple quotes enumerates the sub-steps associated with the macro-step.  
 A pleasing aspect is the familiar syntax the sub-steps have: they closely look to genuine steps of a scenario.  
Sub-steps can also have macro arguments. 
 For instance, the previous step sequence could have two arguments called _userid_ and _password_:  
```cucumber  
  """  
  Given I landed in the homepage   
  And I fill in "Username" with "<userid>"  
  And I fill in "Password" with "<password>"  
  And I click "Sign in"  
  """  
``` 

### Using (invoking) a macro-step ###
A macro-step can only be invoked after its definition has been read by Cucumber.  
The syntax rules for using a given macro-step in a scenario are pretty straightforward:  
- Follow closely the syntax of the _quoted sentence_ in the macro definition.  
- Replace every \<argument\> in the _phrase_ by its actual value between quotes.  

#### Example 1: ####
Consider the following macro-step definition:  
```cucumber
  Given I define the step "When I [log in as <userid>]" to mean: 
  """
  # Sub-steps come here...
  """
```

Its quoted sentence is ```"When I [log in as <userid>]"```, therefore
 the macro-step can be invoked in a scenario like this:  
```cucumber
  Given I do this ...
  When I [log in as "jdoe"]
  And I do that...
```  

#### Example 2: ####
Here is another -partial- macro-step definition:  
```cucumber
  Given I define the step "When I [travel from <origin> to <destination> via <stop>]" to mean: 
  """
  # Sub-steps come here...
  """
```

This macro-step can occur in a scenario as:  
```cucumber
  When I [travel from "San Francisco" to "New-York" via "Las Vegas"]
```

The actual values for the arguments _origin_, _destination_ and _stop_ are
respectively San Francisco, New-York and Las Vegas.


### Passing argument data via a table  ###
Passing more than three arguments in the phrase becomes problematic for readability reasons.
 One ends up with lengthy and clumsy steps.  
Therefore __Macros4Cuke__ has an alternative way to pass data values via a Gherkin table.  
To enable this mechanism for a given macro, ensure that in its definition the quoted sentence ends with
a terminating colon (:) character.

The next example is based on one of the demo feature files:  
```cucumber
  # Next step has a colon ':'  after the ']': data can be passed with a table
  Given I define the step "When I [enter my address as follows]:" to mean:
  """
  When I fill in firstname with "<firstname>"  
  And I fill in lastname with  "<lastname>"  
  And I fill in street with "<street_address>"  
  And I fill in postcode with "<postcode>"  
  And I fill in locality with "<city>"  
  And I fill in country with "<country>"  
  """
```

This step can be used like this:
```cucumber
  When I [enter my address as follows]:"  
  |lastname|Doe|  
  |firstname|John|  
  |street_address| Main Street, 22|  
  |city| Old White Castle|  
  |postcode|JK345|  
```
  
Here are few observations worth noticing:   
- The data table has two columns.  
- Each row is of the form: |argument name| actual value|. For instance, the argument _street_address_ takes
the value "Main Street, 22".  
- Data rows don't have to follow strictly the order of the arguments in the sub-step sequence. 

Copyright
---------
Copyright (c) 2013, Dimitri Geshef. Macros4Cuke is released under the MIT License see [LICENSE.txt](https://github.com/famished-tiger/Macros4Cuke/blob/master/LICENSE.txt) for details.