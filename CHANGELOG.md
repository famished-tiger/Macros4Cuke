## 0.3.04 / 2013-05-12
* [NEW] File `.travis.yml`: Added for integration with Travis CI
* [NEW] File `Gemfile`: Added for integration with Bundler
* [NEW] File `Rakefile`: Added with test tasks
* [CHANGE] File `macros4cuke.gemspec`: added development dependency on rake. 

## 0.3.03 / 2013-05-11
* [CHANGE] File `README.md`: added section on conditional section.

## 0.3.02 / 2013-05-11
* [FIX] File `macro_steps.rb`: Recovered. Was missing in the 0.3.01 gem!

## 0.3.01 / 2013-05-10
* [NEW] features/ folder: added `demo06.feature` file showing the new conditional section.
* [NEW] File `placeholder_spec.rb`: Added a RSpec file to test the Placeholder class.
* [CHANGE] File `macro_steps.rb` Macro-step definition accepts the '*' Gherkin keyword.
* [CHANGE] Method `Engine#compile_sction` completed and tested to support section elements.
* [CHANGE] Method `Section#variables` expanded to support section elements.
* [CHANGE] Method `Engine#variables` expanded to support section elements.
* [CHANGE] Method `Engine#compile_line` added two formatting rules. 
* [CHANGE] Method `MacroStep#scan_arguments` now un-escape the \" sequence into plain quote.
* [CHANGE] examples/ folder expanded and reorganized
* [FIX] Method `Section#render` fixed typo in call to __method__

## 0.3.00 / 2013-05-09 Version number bumped
* [CHANGE] Class `Templating::Engine` can handle conditional tags (TODO: document).
* [CHANGE] File `engine_spec.rb`: Added a RSpec examples to test the conditional tags.


## 0.2.22 / 2013-05-08
 [CHANGE] File `README.md`: expanded the section on macro arguments.

## 0.2.21 / 2013-05-08
* [NEW] Added new class `Templating::UnaryElement`.
* [CHANGE] Made `Placeholder` class inherit from `UnaryElement`.
* [NEW] Added new class `Templating::Section`, a subclass of `UnaryElement`.
* [NEW] Added new class `Templating::ConditionalSection, a subclass of `Section`.
* [CHANGE] Method Engine#parse_tag modified in prevision of conditional tags.
* [NEW] File `section_spec.rb`: Added a RSpec file to test the Conditional class.

## 0.2.20 / 2013-05-07
* [NEW] Added `examples` folder with a first example of an internationalized customisation of __Macros4Cuke__.

## 0.2.19 / 2013-05-07
* [CHANGE] Added validation of macro argument names in new `Engine::parse_tag` method.
* [CHANGE] InvalidCharError exception added.
* [CHANGE] File `engine_spec.rb`: Added one RSpec example for an invalid argument name.
* [CHANGE] File `README.md`: added a new section on naming macro arguments.

## 0.2.18 / 2013-05-06
* [CHANGE] Amended spec files and added a new demo feature. SimpleCov code coverage raised to more than 97%.
* [CHANGE] Macro-step arguments can be multivalued (experimental)

## 0.2.17 / 2013-05-05
* [CHANGE] File `engine_spec.rb`: Added more RSpec examples. SimpleCov code coverage raised to more than 96%.
* [CHANGE] Added section in README.md


## 0.2.16 / 2013-05-04
* [FEATURE] Added dependency to SimpleCov. It is used to measure test code coverage (the combination of Cucumber and RSpec result in 95.9% code coverage).
* [CHANGE] File `macro-step-support_spec.rb`: Added one RSpec example

## 0.2.15 / 2013-05-03
* [CHANGE] File `macro-step-support_spec.rb`: Added one RSpec example.
* [FIX] Updated gemspec.


## 0.2.14 / 2013-05-03
* [CHANGE] Code comments reformatted to YARD. The command line `yard stats`display a 100% documented score!
* [CHANGE] Moved all classes related to the template engine to the new module Templating.
* [CHANGE] Classes `StaticRep, EOLRep, VariableRep, TemplateEngine` renamed to `StaticText, EOLine, Placeholder, Engine` respectively.
* [CHANGE] Added spec file for `MacroStepSupport` module.
* [CHANGE] Initialization of `MacroStepSupport` singleton changed (no dependency on `extended` hook).

## 0.2.13 / 2013-05-02
* [NEW] File `macro-collection_spec.rb`: partial spec file for the `MacroCollection` class.
* [FIX] `DuplicateMacroError#initialize`: Removed superfluous [ in error message.

## 0.2.12 / 2013-05-01
* [CHANGE] Method `Macros4Cuke#compile` raise an `EmptyArgumentError` exception when a line contains an empty or blank argument.
* [CHANGE] File `template-engine_spec.rb`: Added an example for error case mentioned in previous line.

## 0.2.11 / 2013-05-01
* [CHANGE] File `macros4cuke.gemspec`: Removed dependency on Rake.

## 0.2.10 / 2013-04-30

* [CHANGE] `CHANGELOG.md` replaces `HISTORY.md` file. Partial reformatting of historical entries to [Changelogs Convention](tech-angels.github.com/vandamme/#changelogs-convention)
* [CHANGE] Method `MacroStep#initialize`: added the detection of two inconsistencies in macro arguments.
* [CHANGE] New exception class `UselessPhraseArgument`. Raised when the name of an argument from the phrase never appears in a sub-step.
* [CHANGE] New exception class `UnreachableSubstepArgument`. Raised when the name of an argument from a subset never appears in the phrase and the macro-step doesn't allow table.
* [CHANGE] New exception class `DataTableNotFound`. Raised when a step expecting a data table arguments gets anything else.
* [CHANGE] File `macro-step_spec.rb`: Added examples covering the new validation rules in `MacroStep#initialize` method.
* [FIX] `UnknownArgumentError#initialize` Typo in error message.

## 0.2.09 / 2013-04-29

* [CHANGE] Added one capturing group in regexp of macro defining step to detect data passing via table.
* [CHANGE] Class `MacroStep`: added an explicit argument for data passing via table mode.


## 0.2.08 / 2013-04-29

* [CHANGE] Signature of `MacroStep#expand` changed.
* [CHANGE] `MacroStep#validate_params` method is now private
* [CHANGE] File `macro-step_spec.rb` updated.
* [CHANGE] `MacroCollection#render_steps`method updated.
* [CHANGE] File `macro-step_spec.rb`: added test case when a macro is called with unknown argument.
* [FIX] macro-step.rb: added a missing `require 'exceptions'`.

## 0.2.07 / 2013-04-29

* [FIX] Editorial improvements in `README.md`, corrected one inaccurate sentence.


## 0.2.06 / 2013-04-28

* [CHANGE] Formatting improvements in `README.md`.


## 0.2.05 / 2013-04-28

* [CHANGE] Expanded `README.md` with macro-step invokation, passing data value via a table.


## 0.2.04 / 2013-4-27

* [FIX] `MacroCollection#add_macro method`: typo correction.


## 0.2.03 / Unreleased

* [CHANGE] Regexp of defining step is more general: it accepts the Gherkin adverbs `Given, When, Then, And`.


## 0.2.02 / 2013-4-26

* [CHANGE] Added an example in `template-engine_spec.rb` file.
* [CHANGE] Expanded `README.md` file.


## 0.2.01 / 2013-4-26

* [CHANGE] Regexps in step definitions accept escape character sequence. 
* [CHANGE] Expanded `README.md` file.
* [FIX] Corrected remnant of Mustache template in `travelling_demo.feature` file.


## 0.2.00  / 2013-4-25  Version number was bumped

* [CHANGE] Replaced the Mustache template engine by own lightweight TemplateEngine
* [CHANGE] Macro-step arguments have a syntax that is closer to Gherkin's scenario outlines.
* [CHANGE] Upgraded TemplateEngine class to become a simple templating system.
* [CHANGE] Remove dependency to mustache gem.
* [CHANGE] All demos updated to new syntax.
* [CHANGE] examples in `README.md` updated.


## 0.1.07 / 2013-4-24

* [CHANGE] Added new class `TemplateEngine`.


## 0.1.06 / 2013-4-24

* [FIX] Format fix in README.md
* [FIX] `HISTORY.md` file updated with missing entries/


## 0.1.05 / Unreleased

* [CHANGE] `demo_steps.rb`. Added few step definitions that emit output to the screen (so that at least something is shown in the demo).  
* [CHANGE] `MacroStep` class: regexp slightly reworked to accept escaped double quotes in actual values. 
* [CHANGE] `travelling_demo.feature`: Added one example with escaped quotes in actual value.


## 0.1.04 / 2013-4-23

* [ENHANCEMENT] Gherkin comments are allowed in sub-steps sequence. Previous version supported only Mustache comments.
* [CHANGE] Added a few more examples in the `travelling-demo.feature` file.


## 0.1.03 / 2013-4-23

* [CHANGE] `README.md` slightly reworked and added link to Mustache.
* [CHANGE] File `env.rb`: moved all dependencies on Macros4Cuke to the file `macro_support.rb`
* [CHANGE] File `travelling-demo.feature`: Demo feature file with output on the screen (the other demos don't display any result).


## 0.0.02 / 2013-04-21

* [CHANGE] `README.md`: added a reference to the features folder.


## 0.0.01 / 2013-04-21

* [FEATURE] Initial public working version