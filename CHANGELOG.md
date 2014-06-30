### 0.5.06 / 2014-06-30
* [CHANGE] Spec files upgraded to RSpec3.x.x
* [CHANGE] File `Gemfile` updated with dependency on RSpec3
* [CHANGE] File `macros4cuke.gemspec` updated with dependency on RSpec3


### 0.5.05 / 2014-06-30
* [CHANGE] Many files updated for Rubocop 0.24.0. There remain 4 Rubocop offenses.


### 0.5.04 / 2014-04-07
* [CHANGE] File `.rubocop.yml`: Updated for Rubocop 0.20.1. NonNilCheck cop disabled.


### 0.5.03 / 2014-04-01
* [CHANGE] File `README.md`: Updated the installation steps.
* [CHANGE] Files `macro_support.rb` renamed to `use_macros4cuke.rb`

### 0.5.02 / 2014-03-31
* [CHANGE] File `.travis.yml`: Allow build failure with Travis' jruby-head (Travis build scripts miss Bundler install)

### 0.5.01 / 2014-03-31
* [CHANGE] File `macros4cuke`: Removal of command-line option echoing.

### 0.5.00 / 2014-03-31
* [NEW] Added macros4cuke "executable". The CLI simplifies the installation of macros in Cucumber projects.
* [NEW] File `cucumber.rb`: require only this file in order to integrate `Macros4Cuke` in your Cucumber project.
* [CHANGE] File `macros4cuke.gemspec`: Added `bin` and `templates` dirs.
* [NEW] File `exceptions.rb`: New command-line related exception classes.


### 0.4.09 / 2014-03-13
* [CHANGE] Updated source files to comply to Rubocop 0.19.
* [CHANGE] File `.rubocop.yml`: Disabled FileName cop.

### 0.4.08 / 2014-02-08
* [NEW] Added some tutorial material in [Relish] (https://www.relishapp.com/famished-tiger/macros4cuke/docs)
* [CHANGE] `features` dir and feature files re-designed for publishing on Relish website.
* [CHANGE] File `macros4cuke.gemspec`: RDOC is configured to use UTF-8 charset
* [CHANGE] File `README.md`: Updated with links to Relish website.

### 0.4.07 / 2014-02-04
* [FIX] Addressed Rubocop 0.18 complains string concatenation over multiple lines.
* [CHANGE] File `formatting-service_spec.rb`: Replaced string operators + by newline escapes
* [CHANGE] File `engine_spec.rb`: Replaced string operators + by newline escapes
* [CHANGE] File `.rubocop.yml`: Removed two unsupported Cop settings

### 0.4.06 / 2014-01-27
* [FIX] Addressed Rubocop 0.17 complains about bad indentation in some spec files.


### 0.4.05 / 2014-01-14
* [CHANGE] File `.travis.yml`: Added Ruby MRI 2.1.0 to Travis CI
* [CHANGE] File `README.md`: Added sentence explaining where list of macro. defs is placed.
* [CHANGE] File `LICENSE.txt`: Added 2014 to copyright year.

### 0.4.04 / 2013-12-28
* [CHANGE] File `.rubocop.yml`: Updated for Rubocop 0.16. Cop CaseIndentation is now enabled and uses parameters
* [CHANGE] File `engine.rb`: Updated indentation in case statement to comply to latest Rubocop config file.
* [CHANGE] File `section.rb`: Updated indentation in case statement to comply to latest Rubocop config file.
* [CHANGE] File `coll-walker-factory.rb`: Updated indentation in case statement to comply to latest Rubocop config file.


### 0.4.03 / 2013-12-11
* [CHANGE] File `engine.rb`: Monolithic file splitted into more class-specific files.
* [CHANGE] File `constants.rb`: Removal of legacy app in comment.


### 0.4.02 / 2013-11-17
* [CHANGE] File `README.md`: Added section on new feature: capability to list all macros.
* [CHANGE] Files from `macro_steps.rb`: Added the `require` to enable the new step.

### 0.4.01 / 2013-11-17
* [CHANGE] File `.rubocop.yml`: Disabled a few new 0.15.0 cops
* [CHANGE] Files from `lib` and `spec` dirs updated for Rubocop 0.15.0

### 0.4.00 / 2013-11-17 
#### Version number bumped. New feature: to list all encountered macro definitions into a single feature file.
* [FEATURE] Sample `demo07.feature` file illustrates the new step that will list all macro definitions. 
* [NEW] Class CollWalkerFactory. Creates specialized Enumerators that walk over the macro collection.
* [NEW] Module Formatter. Purpose: Grouping of all classes that render macro definitions
* [NEW] File `all-notifications.rb` List of macro collection visit events.
* [NEW] Class `ToGherkin` A macro-step formatter that outputs back into Gherkin format.
* [NEW] Class `ToNull` A macro-step formatter that outputs nothing.
* [NEW] Class `ToTrace` A macro-step formatter that outputs the macro collection visit events.
* [NEW] Class `Comment` to represent comments appearing in sub-steps source.
* [CHANGE] Method `Engine#parse` parses Gherkin comments into Comment objects.
* [CHANGE] File `.rubocop.yml`: Allow checks of spec files, override settings of some new cops.
* [CHANGE] Replaced calls to Kernel#raise by Kernel#fail

### 0.3.42 / 2013-10-04
* [CHANGE] File `macro_steps.rb`: Regular expression for defining step uses now the /x option.
* [FIX] File `.simplecov` Removal of premature dependency to 'coveralls' gem

### 0.3.41 / 2013-10-03
* [CHANGE] File `env.rb`: Updated the exception handler when requiring `simplecov` to prevent the
  `Do not suppress exceptions` warning.

### 0.3.40 / 2013-10-02
* [CHANGE] File `.rubocop.yml`: Updated the Excludes rule
* [CHANGE] All .rb files: Added an newline at the end of each source file (to please Rubocop).

### 0.3.39 / 2013-07-24
* [CHANGE] File `demo06.feature`: Expanded the comments on the conditional section
* [CHANGE] File `README.md`: Small editorial changes in the 'A quick section' example.

### 0.3.38 / 2013-07-15
* [FIX] In method AmbiguousArgumentValue#initialize: An method argument was not string-interpolated in the error message.
* [CHANGE] File 'macro-step_spec.rb' Test updated to cope with the previous fix.
* [CHANGE] Minor changes in code to please Rubocop 0.9.1
* [CHANGE] File `.rubocop.yml` : exclude /examples and /spec folders from Rubocop checks.

### 0.3.37 / 2013-06-27
* [FIX] File `macros4cuke.gemspec`: added README.md in extra_rdoc_files option.
* [CHANGE] File `README.md`: Re-formatting so that it is better rendered with darkfish (from YARD).
* [CHANGE] File `.yardopts` : grouped the exclude options on one line. 

### 0.3.36 / 2013-06-27
* [FIX] File `macros4cuke.gemspec`: corrected the rdoc_options to exclude doc from examples, features and spec folders.
  This was necessary because all but the latest versions of RDoc have difficulties to cope with utf-8.
* [CHANGE] File `.yardopts` : added more folders to exclude from documentation generation. 

### 0.3.35 / 2013-06-27
* [CHANGE] File `macros4cuke.gemspec`: added rdoc_options to exclude doc from examples, features and spec folders.
  This was necessary because all but the latest versions of RDoc have difficulties to cope with utf-8. 

### 0.3.34 / 2013-06-20
* [CHANGE] Most files: Except for the i18n sample files, the utf-8 encoding comment was in all Ruby files of the project.


### 0.3.33 / 2013-06-19
* [CHANGE] File `travis.yml`: Wrong config in Travis CI. As a temporary workaround, removed RVM environments: - jruby-19mode  - ruby-head.

### 0.3.32 / 2013-06-19
* [FIX] File `macros4cuke.gemspec`: Replaced obsolete code for generating the gem (broken with Rubygem v 2+).
* [CHANGE] File `macros4cuke.gemspec`: Added development dependency on rubygem version > 2+


### 0.3.31 / 2013-06-19
* [FIX] File `Rakefile`: A bug in Cucumber's Rake task prevented our rake task to complete. We fix temporarily this by monkey-patching Cucumber code until that project has a fix for it.
* [CHANGE] File ``
* [CHANGE] File `README.md`: Reformulated description in the quick example section.


### 0.3.30 / 2013-06-13
* [CHANGE] File `README.md`: Added section `A word on Step Argument Transforms`.
* [CHANGE] File `engine.rb`: Changed a few case statements in order to please Rubocop.
* [CHANGE] `engine_spec.rb`: A test assertion was missing in a test.
* [TESTED] Regression testing with Cucumber 1.3.2. Pass.

### 0.3.29 / 2013-06-05
* [CHANGE] `MacroStep#validate_params` method: `Extract Method` Refactoring, resulting in new method `MacroStep#validate_row`.
* [CHANGE] `README.md`: Few editorial changes. Added section `More resources`.


### 0.3.28 / 2013-06-03
* [CHANGE] `macros4cuke.gemspec`: Dependencies. Increased version number of RSpec to 2.11.0 (needed after switching to the expect syntax).
* [CHANGE] `Gemfile`: Dependencies. Increased version number of RSpec to 2.11.0.

### 0.3.27 / 2013-05-31
* [FIX] `engine_spec.rb`: Removal of a comment in sample template.
* [CHANGE] `engine_spec.rb`: Removal of an useless test.

### 0.3.26 / 2013-05-31
* [CHANGE] All RSpec files: migrated to the expect syntax instead of the should syntax.
* [CHANGE] `spec_helper.rb`: RSpec is configured to allow the expect syntax only.

### 0.3.25 / 2013-05-30
* [NEW] File `exceptions.rb`: New exception class AmbiguousArgumentValue.
* [CHANGE] Method `MacroStep#validate_params`: an AmbiguousArgumentValue is raised when a macro argument get its value from phrase and data table at the same time.
* [CHANGE] File `macro-step_spec.rb`: Added specific test for new exception.
* [CHANGE] File `README.md`: Added a pre-requisites section and a FAQ section.
* [CHANGE] File `demo_steps.rb`: Removed one Rubocop's complain 'Line is too long'.
* [CHANGE] File `CHANGELOG.md`: change in headings style.

### 0.3.24 / 2013-05-28
* [CHANGE] File `.rubocop.yml`: A few new Rubocop 0.8.0 checks are disabled.
* [CHANGE] Many source files refactored to satisfy new "cops" from Rubocop 0.8.0

### 0.3.23 / 2013-05-26
* [CHANGE] Demo file `table.feature`: Added one scenario combining argument passing via the phrase and table.

### 0.3.22 / 2013-05-25
* [CHANGE] File `macro-collection_spec.rb`: Added one test for the `MacroCollection#render_steps` method.

### 0.3.21 / 2013-05-24
* [CHANGE] File `.rubocop.yml`: StringLiterals cop is now enabled.
* [CHANGE] Many file: replaced double quotes by single quotes in order to pass the StringLiterals Robocop rule.

### 0.3.20 / 2013-05-23
* [CHANGE] File `.travis.yml`: Added more CI environments: ruby-head and jruby-head.
* [CHANGE] File `Rakefile`: Added task to push gem to Rubygems.

### 0.3.19 / 2013-05-22
* [CHANGE] File `.rubocop.yml`: Reduced MethodLength to 30 (lines in a method).
* [CHANGE] Method `Engine#compile_line refactored: Extract Method pattern => new method line_rep_ending added.
* [CHANGE] Method `Engine#compile_sections refactored: Extract Method pattern => new method validate_section_end added.
* [FIX] File `exceptions.rb`: Removal of useless assignment (detected by Rubocop). No runtime impact.


### 0.3.18 / 2013-05-21
* [FEATURE] Support for sub-steps having multiline text arguments (docstring).
* [CHANGE] Method `MacroStep#expand passes` also built-in arguments to template engine.
* [CHANGE] Method `MacroStep#validate_phrase_args` does not apply validations on built-in arguments.
* [CHANGE] File `macro-step_spec.rb`: Added one example to test the insertion of triple quotes.
* [NEW] File `multiline.feature` added in examples/features/ folder.
* [CHANGE] File `README.md`: Added section 'Sub-steps with multiline text argument'

### 0.3.17 / 2013-05-20
* [CHANGE] File `README.md`: Added dynamic dependencies badge (Gemnasium).

### 0.3.16 / 2013-05-20
* [CHANGE] File `demo06.feature`: Added a scenario that causes a specific exception to be raised.
* [CHANGE] File `demo_steps.rb`: Added a specific step that raises a TableNotException. It is captured and compared to expectations. 
* [CHANGE] File `engine.rb`: Removed two lines that were never executed.

### 0.3.15 / 2013-05-20
* [FIX] File `.CHANGELOG.md` Date entries weren't incremented.
* [CHANGE] File `.rubocop.yml`: Added more configuration entries.
* [CHANGE] Spec files updated to better please Rubocop.

### 0.3.14 / 2013-05-18
* [FIX] lib/ folder in secondary local repository was messed up. Gem was OK.

### 0.3.13 / 2013-05-18
* [NEW] File `.rubocop.yml` Added.
* [CHANGE] Many source files changed to please Rubocop.

### 0.3.12 / 2013-05-17
* [NEW] File `.ruby-gemset` Added (for RVM users).
* [NEW] File `.ruby-version` Added (for RVM users).

### 0.3.11 / 2013-05-16
* [CHANGE] File `README.md`: Minor reformating.
* [CHANGE] File `basic.feature` (in examples/): Added one more macro-step example.

### 0.3.10 / 2013-05-15
* [CHANGE] File `README.md`: Expanded section on conditional section.
* [CHANGE] Method `Templating::Engine::parse` slightly refactored in order to decrease its complexity.

### 0.3.09 / 2013-05-14
* [CHANGE] File `.travis.yml`: Added jruby as a target Ruby

### 0.3.08 / 2013-05-13
* [CHANGE] File `README.md`: Added Gem Version badge

### 0.3.07 / 2013-05-12
* [CHANGE] File `README.md`: Added Codeclimate badge

### 0.3.06 / 2013-05-12
* [FIX] File `README.md`: Fixed formatting issue of Travis CI status badge

### 0.3.05 / 2013-05-12 Unreleased
* [CHANGE] File `README.md`: Added Travis CI status badge

### 0.3.04 / 2013-05-12 Unreleased
* [NEW] File `.travis.yml`: Added for integration with Travis CI
* [NEW] File `Gemfile`: Added for integration with Bundler
* [NEW] File `Rakefile`: Added with test tasks
* [CHANGE] File `macros4cuke.gemspec`: added development dependency on rake. 

### 0.3.03 / 2013-05-11
* [CHANGE] File `README.md`: added section on conditional section.

### 0.3.02 / 2013-05-11
* [FIX] File `macro_steps.rb`: Recovered. Was missing in the 0.3.01 gem!

### 0.3.01 / 2013-05-10
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

### 0.3.00 / 2013-05-09 Version number bumped
* [CHANGE] Class `Templating::Engine` can handle conditional tags (TODO: document).
* [CHANGE] File `engine_spec.rb`: Added a RSpec examples to test the conditional tags.


### 0.2.22 / 2013-05-08
 [CHANGE] File `README.md`: expanded the section on macro arguments.

### 0.2.21 / 2013-05-08
* [NEW] Added new class `Templating::UnaryElement`.
* [CHANGE] Made `Placeholder` class inherit from `UnaryElement`.
* [NEW] Added new class `Templating::Section`, a subclass of `UnaryElement`.
* [NEW] Added new class `Templating::ConditionalSection, a subclass of `Section`.
* [CHANGE] Method Engine#parse_tag modified in prevision of conditional tags.
* [NEW] File `section_spec.rb`: Added a RSpec file to test the Conditional class.

### 0.2.20 / 2013-05-07
* [NEW] Added `examples` folder with a first example of an internationalized customisation of __Macros4Cuke__.

### 0.2.19 / 2013-05-07
* [CHANGE] Added validation of macro argument names in new `Engine::parse_tag` method.
* [CHANGE] InvalidCharError exception added.
* [CHANGE] File `engine_spec.rb`: Added one RSpec example for an invalid argument name.
* [CHANGE] File `README.md`: added a new section on naming macro arguments.

### 0.2.18 / 2013-05-06
* [CHANGE] Amended spec files and added a new demo feature. SimpleCov code coverage raised to more than 97%.
* [CHANGE] Macro-step arguments can be multivalued (experimental)

### 0.2.17 / 2013-05-05
* [CHANGE] File `engine_spec.rb`: Added more RSpec examples. SimpleCov code coverage raised to more than 96%.
* [CHANGE] Added section in README.md


### 0.2.16 / 2013-05-04
* [FEATURE] Added dependency to SimpleCov. It is used to measure test code coverage (the combination of Cucumber and RSpec result in 95.9% code coverage).
* [CHANGE] File `macro-step-support_spec.rb`: Added one RSpec example

### 0.2.15 / 2013-05-03
* [CHANGE] File `macro-step-support_spec.rb`: Added one RSpec example.
* [FIX] Updated gemspec.


### 0.2.14 / 2013-05-03
* [CHANGE] Code comments reformatted to YARD. The command line `yard stats`display a 100% documented score!
* [CHANGE] Moved all classes related to the template engine to the new module Templating.
* [CHANGE] Classes `StaticRep, EOLRep, VariableRep, TemplateEngine` renamed to `StaticText, EOLine, Placeholder, Engine` respectively.
* [CHANGE] Added spec file for `MacroStepSupport` module.
* [CHANGE] Initialization of `MacroStepSupport` singleton changed (no dependency on `extended` hook).

### 0.2.13 / 2013-05-02
* [NEW] File `macro-collection_spec.rb`: partial spec file for the `MacroCollection` class.
* [FIX] `DuplicateMacroError#initialize`: Removed superfluous [ in error message.

### 0.2.12 / 2013-05-01
* [CHANGE] Method `Macros4Cuke#compile` raise an `EmptyArgumentError` exception when a line contains an empty or blank argument.
* [CHANGE] File `template-engine_spec.rb`: Added an example for error case mentioned in previous line.

### 0.2.11 / 2013-05-01
* [CHANGE] File `macros4cuke.gemspec`: Removed dependency on Rake.

### 0.2.10 / 2013-04-30

* [CHANGE] `CHANGELOG.md` replaces `HISTORY.md` file. Partial reformatting of historical entries to [Changelogs Convention](tech-angels.github.com/vandamme/#changelogs-convention)
* [CHANGE] Method `MacroStep#initialize`: added the detection of two inconsistencies in macro arguments.
* [CHANGE] New exception class `UselessPhraseArgument`. Raised when the name of an argument from the phrase never appears in a sub-step.
* [CHANGE] New exception class `UnreachableSubstepArgument`. Raised when the name of an argument from a subset never appears in the phrase and the macro-step doesn't allow table.
* [CHANGE] New exception class `DataTableNotFound`. Raised when a step expecting a data table arguments gets anything else.
* [CHANGE] File `macro-step_spec.rb`: Added examples covering the new validation rules in `MacroStep#initialize` method.
* [FIX] `UnknownArgumentError#initialize` Typo in error message.

### 0.2.09 / 2013-04-29

* [CHANGE] Added one capturing group in regexp of macro defining step to detect data passing via table.
* [CHANGE] Class `MacroStep`: added an explicit argument for data passing via table mode.


### 0.2.08 / 2013-04-29

* [CHANGE] Signature of `MacroStep#expand` changed.
* [CHANGE] `MacroStep#validate_params` method is now private
* [CHANGE] File `macro-step_spec.rb` updated.
* [CHANGE] `MacroCollection#render_steps`method updated.
* [CHANGE] File `macro-step_spec.rb`: added test case when a macro is called with unknown argument.
* [FIX] macro-step.rb: added a missing `require 'exceptions'`.

### 0.2.07 / 2013-04-29

* [FIX] Editorial improvements in `README.md`, corrected one inaccurate sentence.


### 0.2.06 / 2013-04-28

* [CHANGE] Formatting improvements in `README.md`.


### 0.2.05 / 2013-04-28

* [CHANGE] Expanded `README.md` with macro-step invokation, passing data value via a table.


### 0.2.04 / 2013-4-27

* [FIX] `MacroCollection#add_macro method`: typo correction.


### 0.2.03 / Unreleased

* [CHANGE] Regexp of defining step is more general: it accepts the Gherkin adverbs `Given, When, Then, And`.


### 0.2.02 / 2013-4-26

* [CHANGE] Added an example in `template-engine_spec.rb` file.
* [CHANGE] Expanded `README.md` file.


### 0.2.01 / 2013-4-26

* [CHANGE] Regexps in step definitions accept escape character sequence. 
* [CHANGE] Expanded `README.md` file.
* [FIX] Corrected remnant of Mustache template in `travelling_demo.feature` file.


### 0.2.00  / 2013-4-25  Version number was bumped

* [CHANGE] Replaced the Mustache template engine by own lightweight TemplateEngine
* [CHANGE] Macro-step arguments have a syntax that is closer to Gherkin's scenario outlines.
* [CHANGE] Upgraded TemplateEngine class to become a simple templating system.
* [CHANGE] Remove dependency to mustache gem.
* [CHANGE] All demos updated to new syntax.
* [CHANGE] examples in `README.md` updated.


### 0.1.07 / 2013-4-24

* [CHANGE] Added new class `TemplateEngine`.


### 0.1.06 / 2013-4-24

* [FIX] Format fix in README.md
* [FIX] `HISTORY.md` file updated with missing entries/


### 0.1.05 / Unreleased

* [CHANGE] `demo_steps.rb`. Added few step definitions that emit output to the screen (so that at least something is shown in the demo).  
* [CHANGE] `MacroStep` class: regexp slightly reworked to accept escaped double quotes in actual values. 
* [CHANGE] `travelling_demo.feature`: Added one example with escaped quotes in actual value.


### 0.1.04 / 2013-4-23

* [ENHANCEMENT] Gherkin comments are allowed in sub-steps sequence. Previous version supported only Mustache comments.
* [CHANGE] Added a few more examples in the `travelling-demo.feature` file.


### 0.1.03 / 2013-4-23

* [CHANGE] `README.md` slightly reworked and added link to Mustache.
* [CHANGE] File `env.rb`: moved all dependencies on Macros4Cuke to the file `macro_support.rb`
* [CHANGE] File `travelling-demo.feature`: Demo feature file with output on the screen (the other demos don't display any result).


### 0.0.02 / 2013-04-21

* [CHANGE] `README.md`: added a reference to the features folder.


### 0.0.01 / 2013-04-21

* [FEATURE] Initial public working version