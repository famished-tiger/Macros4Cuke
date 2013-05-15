Macros4Cuke
===========
[![Build Status](https://travis-ci.org/famished-tiger/Macros4Cuke.png?branch=master)](https://travis-ci.org/famished-tiger/Macros4Cuke)
[![Code Climate](https://codeclimate.com/github/famished-tiger/Macros4Cuke.png)](https://codeclimate.com/github/famished-tiger/Macros4Cuke.png)
[![Gem Version](https://badge.fury.io/rb/macros4cuke.png)](http://badge.fury.io/rb/macros4cuke)

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

In addtion, since version 0.3.01:
* Sub-steps can be made conditional.

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
  
```ruby
# /features/support/env.rb
# Add the two next lines
require 'macros4cuke'  
World(Macros4Cuke::MacroStepSupport)
```  
  
* Step 2: Import the macro-management steps  
In your `/features/step_definitions/` folder:  
  - The cleanest is to create a Ruby file (say, 'use\_macro\_steps.rb') with the line:  
  
```ruby  
require 'macros4cuke/../macro_steps'
```  
  - Alternatively, you could directly add the require in one of your step definition file.
 
  
That's it! Now you can start writing macros in your Cucumber project.


## Getting started ##
Working with a macro-step is a two-stages process:  
1. Defining a new macro-step; and,  
2. Using that macro-step in a scenario.

Let's begin by taking a closer look at the definition part.
### Defining a macro-step ###
To create a macro-step, you'll need to use a __defining__ step bundled with Macros4Cuke.
It is a rather unusual Cucumber step in the sense that its sole purpose is to build another step!  
The _defining step_ follows the general pattern:
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
Its syntax is defined like this:  
- The text outside the square brackets follows a fixed pattern. In other words,
 the quoted sentence MUST always start as follows: ```"When I [...```. Notice however,
 that the Given, Then and '*' keywords are also allowed.  
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
Passing more than three arguments in the phrase becomes problematic from a readability viewpoint.
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

## Macro-step arguments ##

### Argument names ###
In line with most computer languages, Macros4Cuke accepts argument names containing alphanumeric characters and 
underscores.  
In fact, the only characters that are not allowed in argument names are the following punctuation or delimiting
signs:  
__\!"'\#$%\&\*\+\-/,\.\:\;\=\?\(\)\<\>\[\]\{\}\\\^\`\|\~__


### Assigning a value to an argument ###
An argument appearing in the phrase MUST always be bound to a value at the step invokation.
Taking again a previous example of a -partial- macro-step definition:  
```cucumber
  Given I define the step "When I [travel from <origin> to <destination> via <stop>]" to mean: 
  """
  # Sub-steps come here...
  """
```

The following step invokation is invalid:
```cucumber
  When I [travel from "San Francisco" to via "Las Vegas"]
```

The issue is: the destination value is missing, Macros4Cuke won't be able to find a step with that syntax.  
The next invokation is syntactically correct for Macros4Cuke:
```cucumber
  When I [travel from "San Francisco" to "" via "Las Vegas"]
```

The _destination_ argument gets an empty text as actual value. 

For any argument that can receive a value through a data table, three situations can occur:  
1. A row for that argument together with a text value are specified at invokation. The argument is bound to that text value.  
2. A row for that argument and an empty text value are specified at invokation. The argument is bound to an empty text.  
3. There is no row for that argument. The argument is unbound (nil) but is rendered as an empty text.  


## Conditional sections in substeps. ##
To make the macros more flexible, it is possible to define conditional sections in the substep sequence.  
The general pattern for the conditional section is:  
```cucumber
  <?foobar>
  substep1
  substep2
  </foobar>
```

This works like this:
```<?foobar>``` marks the begin of a conditional section. The end of that section is marked by ```</foobar>```.  
Anything that is in this section will be executed provided the argument ```foobar``` has a value bound to it.
Stated otherwise, when ```foobar``` has no value at invokation, then ```substep1``` and ```substep2``` will be skipped.  
Conditional sections are useful for steps that are optional or for which an empty value '' isn't equal to no value.
This is the case in user interface testing: skipping a field or entering a field and leaving it empty may
lead to very different system behaviour (e.g. setting the focus in a field can trigger UI-events).  

Consider the following example:  

```cucumber
  Given I define the step "* I [fill in the form with]:" to mean:
  """
  When I fill in "first_name" with "<firstname>"
  And I fill in "last_name" with "<lastname>"
  And I fill in "street_address" with "<street_address>"
  And I fill in "zip" with "<postcode>"
  And I fill in "city" with "<city>"
  # Let's assume that e-mail is optional
  <?email>
  And I fill in "email" with "<email>"
  </email>
  And I click "Save"
  """
```

When invoked like this:  
```cucumber
  When I [fill in the form with]:
  |firstname     |Alice|
  |lastname      | Inn |
  |street_address| 11, No Street|
  |city| Nowhere-City|
  |country|Wonderland|
```

the following substep sequence is executed:
```cucumber
  When I fill in "first_name" with "Alice"
  And I fill in "last_name" with "Inn"
  And I fill in "street_address" with "11, No Street"
  And I fill in "zip" with ""
  And I fill in "city" with "Nowhere-City"
  And I click "Save"
```

A few remarks concerning the executed sequence:  
1. Every macro argument (say, firstname) that takes a value (say, "Alice"), is replaced
 that by that value in the substeps.  
2. Every macro argument (say, zip) that doesn't have a corresponding row in the data table,
 is replaced by an empty text (look at the substep for the zip code entry).  
3. The substep with the email entry doesn't appear at all. This can be explained by the conditional
section <?email>...</email> that prevents the enclosed substep(s) to be generated in absence of a value for
the email macro argument.


A typical use case for conditional sections is to prevent the execution of one or more steps in
absence of a given data item. This simulates, for instance, the behaviour of a user that skips 
one or more widgets in a page/screen. From a user interface testing viewpoint, entering an empty
text in an entry field may be noticeably different than skipping that same entry field.
Think of specific UI-events that can trigger some special system response.




## With great power comes great responsibility. ##
_Stan Lee_  

Our experience is that macro-steps change deeply the way one designs and writes feature files.  
Macro-steps are most useful in UI-testing (e.g. with tools like Capybara) because they help to close
 the gap between the user's intent and the low-level user interface actions.   
In addition __Macros4Cuke__ allows advanced users to craft their own steps without having to program step definitions.
This last argument becomes important in the context of user acceptance testing, a domain where the assumption that
 every tester is also Rubyist is -alas!- far from the truth.

 
Macros with Cucumber is highly debated topic, so it is always wise to know what other people say about it:  
[Support for Macros] (https://github.com/cucumber/gherkin/issues/178)  
[Substeps - macro request for the nth time] (http://grokbase.com/t/gg/cukes/133ey063b8/cucumber-substeps-macro-request-for-the-nth-time)


Copyright
---------
Copyright (c) 2013, Dimitri Geshef. Macros4Cuke is released under the MIT License see [LICENSE.txt](https://github.com/famished-tiger/Macros4Cuke/blob/master/LICENSE.txt) for details.