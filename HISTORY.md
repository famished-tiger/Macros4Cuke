## [0.2.04]
### Fixes:
* Class MacroCollection#add_macro: typo correction.

## [0.2.03]
### Changes:
* Regexp of defining step is more general: it accepts the Gherkin adverbs Given, When, Then, And.


## [0.2.02]
### Changes:
* Added an example in template-engine_spec.rb file. 

### Documentation:
* Expanded the README.md file.

## [0.2.01]
### Changes:
* Regexp in the step definitions are more robust: they accept escape character sequence. 

### Fixes:
* Corrected remnant of Mustache template in travelling_demo.feature file.


### Documentation:
* Expanded the README.md file.


## [0.2.00] Version number was bumped
### Changes:
* Replaced the Mustache template engine by own lightweight TemplateEngine
* Macro-step arguments have a syntax that is closer to Gherkin's scenario outlines.
* Upgraded TemplateEngine class to become a simple templating system.
* Remove dependency to mustache gem.

### Documentation:
* All demos updated to new syntax.
* Updated the examples in README.md


## [0.1.07]
### Changes:
* Added new class TemplateEngine.


## [0.1.06]

### Documentation:
* Format fix in README.md
* HISTORY.md file updated

## [0.1.05]
### Changes:
* demo_steps.rb: A few step definitions emits output to the screen (so that at least something is shown in the demo).  
* MacroStep class: regexp slightly reworked to accept escaped double quotes in actual values. 
* travelling_demo.feature: added one example with escaped quotes in actual value.


## [0.1.04]
### New features:
* Gherkin comments are allowed in sub-steps sequence. Previous version supported only Mustache comments.

### Changes:
* Added a few more examples in the 'travelling-demo.feature' file.


## [0.1.03]
### Documentation
* README.md: slightly reworked and added link to Mustache.

### Changes:
* env.rb: All dependencies on Macros4Cuke were moved to the file macro_support.rb
* travelling-demo.feature: Demo feature file with output on the screen (the other demos don't display any result).


## [0.0.02]
### Documentation
* In README: added a reference to the features folder.

## [0.0.01]

### New features
* Initial public working version