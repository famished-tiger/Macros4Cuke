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

## A quick example ##
Here is an example taken from our demo files:  
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

When it is executed, the last macro-step (invokation) as the same effect as:  
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

See also the working examples in the features folder.

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
1. First, the definition of a new macro-step  
2. Second, the use of that macro-step in a scenario.

Let's begin by taking a closer look at the definition step.
### Defining a macro-step ###
There are three questions to keep in mind when creating a new macro-step:  
1. What is its syntax?  
2. What are its substeps?     
3. Does it need arguments?  

#### Specifying the syntax of a macro-step ####
Let's begin with a simple example: 
```cucumber
  Given I define the step "When I [enter my credentials]" to mean:  
  """  
  Given I landed in the homepage   
  And I fill in "Username" with "tweedledum"  
  And I fill in "Password" with "tweedledee"  
  And I click "Sign in"  
  """  
```

The first line in the snippet is a step that helps to define macro-step.
It is a perfectly valid step once your Cucumber project was configured to use __Macros4Cuke__
 as explained in the Setup section above.  
The syntax of a macro-step sentence is defined by its __phrase__, that is, the text on the first line that appears
 between square brackets [...].
In the example at hand, the _phrase_ is the text:  
```cucumber
  [enter my credentials] 
``` 

A few remarks about the __phrase__ part:  
- It must be unique. In other words, it is not possible to create another
  macro-step with the same phrase. In fact, Macros4Cuke uses the phrase internally as a mean to identify/name
  a macro-step.  
- It may have one or more arguments. The example above illustrates the simplest case where no argument
is placed inside the phrase.  
Besides that, the text inside the phrase can be arbitrary (well, almost).

The next phrase takes two arguments:  
```cucumber
  [travel from <origin> to <destination>] 
```  

Each argument (variable), is enclosed between <...> chevrons. In our last example,
the argument names are: _origin_ and _destination_. Notice that _origin_ and _destination_ are
 variable names that will take a value (if any) when the step is invoked _(more on this later)_.

#### Specifying the sub-steps of a macro-step ####
The sub-steps are placed in a Gherkin multiline text, that is, a text that is enclosed between 
 triple quotes ("""). In the earlier example, the text 
```cucumber  
  """  
  Given I landed in the homepage   
  And I fill in "Username" with "tweedledum"  
  And I fill in "Password" with "tweedledee"  
  And I click "Sign in"  
  """  
```  
enumerates the sub-steps associated with the macro-step. A pleasing aspect is the familiar syntax 
 the sub-steps have: they closely look to steps in a genuine scenario. Sub-steps can also have macro arguments.  
 For instance, the previous step sequence may have two arguments called _userid_ and _password_:
```cucumber  
  """  
  Given I landed in the homepage   
  And I fill in "Username" with "<userid>"  
  And I fill in "Password" with "<password>"  
  And I click "Sign in"  
  """  
``` 

 
---

Copyright
---------
Copyright (c) 2013, Dimitri Geshef. See [LICENSE.txt](https://github.com/famished-tiger/Macros4Cuke/blob/master/LICENSE.txt) for details.