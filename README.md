Macros4Cuke
===========
_Extend Cucumber with macro-steps._  
[Homepage](https://github.com/famished-tiger/Macros4Cuke)  
[Documentation] (https://www.relishapp.com/famished-tiger/macros4cuke/docs)

[![Build Status](https://travis-ci.org/famished-tiger/Macros4Cuke.png?branch=master)](https://travis-ci.org/famished-tiger/Macros4Cuke)
[![Code Climate](https://codeclimate.com/github/famished-tiger/Macros4Cuke.png)](https://codeclimate.com/github/famished-tiger/Macros4Cuke.png)
[![Gem Version](https://badge.fury.io/rb/macros4cuke.png)](http://badge.fury.io/rb/macros4cuke)
[![Dependency Status](https://gemnasium.com/famished-tiger/Macros4Cuke.png)](https://gemnasium.com/famished-tiger/Macros4Cuke)


__Macros4Cuke__ is a Cucumber extension that adds a macro facility for your Cucumber scenarios.  
  With it, you can create any new step that replaces a sequence of sub-steps.
  All this can be done directly in your feature files without programming step definitions.

### Highlights ###
* Works with out-of-the-box Cucumber
* Simple installation and setup (no programming required),
* Familiar syntax for macro-step definitions,
* Substep sequence can be of arbitrary length,
* Macro-steps may have data arguments,
* Data values can be passed to the sub-steps,
* Domain neutral: applicable to any kind of application that can be driven with Cucumber,
* A group of sub-steps can be made conditional.


Since version 0.4.00, it is also possible to [list all the encountered macro definitions](#listing-all-the-macro-definitions). 

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

The first line above specifies the syntax of the macro-step (it is the text between the square brackets).  
Notice also how the macro-step arguments _userid_ and _password_ are enclosed between chevrons (angle brackets) <...>.
Finally, the text lines between by the triple quotes """ represent the Cucumber steps to execute when
the macro-step is invoked(used) elsewhere in a feature file.


That macro-step can then be used/invoked in a scenario like this:  

```cucumber 
    When I [enter my userid "jdoe" and password "hello-world"]
```

Once it is executing, the invoked macro-step should be equivalent to:  

```cucumber 
    Given I landed in the homepage  
    When I click "Sign in"  
    And I fill in "Username" with "jdoe"  
    And I fill in "Password" with "hello-world"  
    And I click "Submit"    
```

In other words, this sequence of 5 steps can be replaced by just one.
Macros4Cuke not only helps in getting rid of the repeated step sequences,
 it allows the feature writers to create themselves higher-level steps
 that are closer to the business logic.  

See also the working examples in the ```features/``` folder.
Nicely formatted documentation extracted from these feature files is also available on the [Relish website](https://www.relishapp.com/famished-tiger/macros4cuke/docs)

## Setup ##
### Pre-requisites ###

Macros4Cuke works with:  
- MRI Ruby 1.9.x, 2.0.x and 2.1.x.  
- JRuby (was tested with version 1.7.3 and above),  
- Rubinius 2.x

Macros4Cuke requires Cucumber.

### Installation ###
The macros4cuke gem installation is fairly standard.  
If you have a `Gemfile`, add `macros4cuke` to it. Otherwise, install the gem like this:
 
```bash  
$[sudo] gem install macros4cuke
```

### Configuring your Cucumber projects ####
The procedure to add support for macros in an existing Cucumber project
was simplified since version 0.5.00. 
 
There are two possible ways to do it:  
- By editing manually a support file; or,  
- Let Macros4cuke configure your project.   
 
#### Alternative 1: manually add one line in a support file  
Require the library in one of your ruby files under `features/support` (e.g. `env.rb`):  
 
```ruby
# /features/support/env.rb
# Add the next single line
require 'macros4cuke/cucumber'  
``` 

That's it! Now you can start writing macros in your Cucumber project.

#### Alternative 2: let macros4cuke configure your project

Use the following command-line:
```bash  
$[sudo] macros4cuke --setup project_path
```

Where __project_path__ is the location of your Cucumber project.  
In case the working directory of the shell/command prompt is
already the directory containing the Cucumber project, then the
command-line is simply:  
```bash  
$[sudo] macros4cuke --setup .
``` 

Notice that ending dot above means "the current directory".


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

## Sub-steps with multiline text argument ##
- __Question__: is it possible to define a macro-step with a sub-step that itself
 uses a multiline text argument (also called a docstring)?  
- __Answer__: Yes but there is a catch.

Consider the following attempt of a macro-step definition:  

```cucumber
  Given I define the step "* I [make a long journey]" to mean:
  """
    When I visit the cities:
    """
    Amsterdam
    Brussels
    Copenhagen
    """
  """
```

This will result in an error. The issue is caused by the nesting of triple quotes:
Cucumber simply doesn't allow this. In fact, the error is reported by [Gherkin](https://github.com/cucumber/gherkin), 
a component used by Cucumber.  
As Gherkin has other [issues](https://github.com/cucumber/gherkin/issues/124) with docstrings, we
need a workaround today until the fixes are applied.  
The workaround is the following:  
- There exists in Macros4Cuke a predefined sub-step argument called __\<quotes\>__ and its value
is set to a triple quote sequence """.  
- Use it everywhere you want to place nested triple quotes.

Thus to make the previous example work, one must change it like follows:  

```cucumber
  Given I define the step "* I [make a long journey]" to mean:
  """
    When I visit the cities:
    <quotes>
    Amsterdam
    Brussels
    Copenhagen
    <quotes>
  """
```


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


## More documentation ##
More samples and documentation can be found in the `features` folder. It contains
many feature files and README.md -in Markdown format-.
Most of the material has been rewritten and adapted so that it can be consulted at the Relish website.
Relish -The living document- website is great to turn your feature files into an attractive documentation.

[Macros4Cuke @ Relish] (https://www.relishapp.com/famished-tiger/macros4cuke/docs)


## Listing all the macro definitions ##
When one begins to write macros spread over a large collection of feature files
 it becomes interesting to have an overview, a list of all macro ever defined.  
Therefore _Macros4Cuke_ comes with a pre-defined step that generates such a list of macro definitions.  
This specialized step has the following syntax:

```cucumber
  When I want to list all the macros in the file "all_macros.feature"
```

Where `all_macros.feature` is a feature file that will be generated when Cucumber
terminates. The resulting feature file lists all the macros (one per scenario) in 
the familiar Gherkin syntax. The file is placed in the current directory (i.e. the directory where
Cucumber was launched).



## A word on Step Argument Transforms##
Cucumber provides a handy facility that helps to convert implicitly the values of step arguments.
A first description of this lesser-known functionality is available at 
[Step Argument Transforms] (https://github.com/cucumber/cucumber/wiki/Step-Argument-Transforms).  
Does Macros4Cuke provide such a facility for its own macro-step arguments?  
The answer is no: if macro-steps had their own kind of transformations, then these would have interfere with the ones defined directly in Cucumber.
In fact, Cucumber will happily apply transformations on any step, including the macro definition steps and the
steps invoking macros. Stated otherwise, all the rules pertaining to the Step Argument Transforms work as usual. Or almost. 
There is one very specific case where Cucumber behaves slightly differently: the transforms aren't applied when a sub-step is executed.
Internally, Macros4Cuke calls the `Cucumber::RbSupport::RbWorld::#steps` method that allows to run a Gherkin snippet (the substeps),
and it appears that this method does not trigger the transforms. In practice, this doesn't prevent the use of transforms together
with Macros4Cuke. In the vast majority of cases both will work fine as expected.


## FAQ ##
__Q__: Can I define a macro in one scenario and invoke it in another scenario in the same feature file?  
__A__: Yes. Once a macro is defined in a feature file it can be invoked in any scenario that follows the definition.  
In fact, the macro can be invoked in any scenario from any feature file, provided the invokation takes place _after_ the 
macro definition.  

__Q__: So, a macro can be shared between multiple files.  
__A__: Indeed. This is similar to genuine step definitions which are global (accessible to every feature files).
For macro-steps, again, they can be used anywhere after their definition.  

__Q__: How should I pass arguments: via the phrase or a data table?  
__A__: Both data passing mechanisms can be used at the same time. Favour data value passing
via the phrase when the number of macro arguments is small (say, <= 2).   

__Q__: Can I define a macro-step in a `Background` section?  
__A__: No. Here is why: every step from the Background section is executed in each scenario (outline).
If a macro were defined in the Background, then the macro definition will occur multiple times, which is
 flagged as an error by Macros4Cuke.  
 
__Q__: Can I define a macro-step in a `Scenario Outline`?  
__A__: No, if the scenario outline has multiple rows then an error will occur. Bear in mind,
that steps in a scenario outline are repeating n times, n being the number of rows in the example table.
Since a macro can only be defined once, placing a macro definition in a scenario outline will
most likely cause an error.  

__Q__: Can I __invoke/call__ a macro-step in a `Background` or `Scenario Outline`?  
__A__: Yes. As a macro-step can be invoked multiple times.



## Changelog

Macros4Cuke's changelog is available [here](CHANGELOG.md).
 
## More resources:
-   [**Detailed CI status**](https://travis-ci.org/famished-tiger/Macros4Cuke)
-   [**Suggest an improvement**](https://github.com/famished-tiger/Macros4Cuke/issues)
-   [**Report a bug**](https://github.com/famished-tiger/Macros4Cuke/issues)


### With great power comes great responsibility. ###
_Stan Lee_  

Our experience is that macro-steps change deeply the way one designs and writes feature files.  
Macro-steps are most useful in UI-testing (e.g. with tools like Capybara) because they help to close
 the gap between the user's intent and the low-level user interface actions.   
In addition __Macros4Cuke__ allows advanced users to craft their own steps without having to program step definitions.
This last argument becomes important in the context of user acceptance testing, a domain where the assumption that
 every tester is also Rubyist is -alas!- far from the truth.

 
Macros with Cucumber is a hot topic, so it is good to know what other people say about it:  
[Support for Macros] (https://github.com/cucumber/gherkin/issues/178)  
[Substeps - macro request for the nth time] (http://grokbase.com/t/gg/cukes/133ey063b8/cucumber-substeps-macro-request-for-the-nth-time)


Copyright
---------
Copyright (c) 2014, Dimitri Geshef. Macros4Cuke is released under the MIT License see [LICENSE.txt](https://github.com/famished-tiger/Macros4Cuke/blob/master/LICENSE.txt) for details.