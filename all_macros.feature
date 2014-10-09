# Feature file generated by Macro4Cuke 0.5.06 on 09/10/2014 22:02:19

Feature: the set of macro-step definitions
  As a feature file writer
  So that I write higher-level steps

  Scenario: Macro 1
    Given I define the step "* I [log in]" to mean:
      """
      # Here follows the steps to execute when this macro is called
      Given I landed in the homepage
      When I click "Sign in"
      And I fill in "Username" with "johndoe"
      And I fill in "Password" with "unguessable"
      And I click "Submit"
      """

  Scenario: Macro 2
    Given I define the step "* I [log in as <userid>]" to mean:
      """
      Given I landed in the homepage
      When I click "Sign in"
      # The next step uses the macro-step argument <userid>
      And I fill in "Username" with "<userid>"
      And I fill in "Password" with "unguessable"
      And I click "Submit"
      """

  Scenario: Macro 3
    Given I define the step "* I [enter my userid <userid> and password <password>]" to mean:
      """
      Given I landed in the homepage
      When I click "Sign in"
      And I fill in "Username" with "<userid>"
      And I fill in "Password" with "<password>"
      And I click "Submit"
      """

  Scenario: Macro 4
    Given I define the step "* I [enter my credentials as]:" to mean:
      """
      Given I landed in the homepage
      When I click "Sign in"
      And I fill in "Username" with "<userid>"
      And I fill in "Password" with "<password>"
      And I click "Submit"
      """

  Scenario: Macro 5
    Given I define the step "* I [enter my profile as]:" to mean:
      """
      And I fill in "location" with "<location>"
      And I fill in "email" with "<email>"
      And I fill in "comment" with "<comment>"
      And I click "Save"
      """

  Scenario: Macro 6
    Given I define the step "* I [fill in the form with]:" to mean:
      """
      When I fill in "first_name" with "<firstname>"
      And I fill in "last_name" with "<lastname>"
      And I fill in "street_address" with "<street_address>"
      And I fill in "zip" with "<postcode>"
      And I fill in "city" with "<city>"
      And I fill in "country" with "<country>"
      
      # Let's assume that the e-mail field is optional.
      # The step between the <?email>...<email> will be executed
      # only when the argument <email> has a value assigned to it.
      <?email>
      And I fill in "email" with "<email>"
      </email>
      
      # Let's also assume that comment is also optional
      # See the slightly different syntax: the conditional section
      # <?comment>...<comment> may fit in a single line
      <?comment>  And I fill in "comment" with "<comment>"</comment>
      And I click "Save"
      """

  Scenario: Macro 7
    Given I define the step "* I [enter my credentials]" to mean:
      """
      # The next step invokes a macro-step defined elsewhere
      When I [enter my userid "guest" and password "unguessable"]
      """

