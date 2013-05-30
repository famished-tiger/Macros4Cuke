# File: multiline.feature

Feature: Show how to use multiline text inside macros
  As a Cuke user
  So that I enjoy writing scenario.


Scenario: Using a step with multiline text argument
  When I visit the cities:
  """
  Amsterdam
  Brussels
  Copenhagen
  """

Scenario: Definition of macro-step having a substep with multiline text
  Given I define the step "* I [make a long journey from <origin> to <destination>]" to mean:
  """
  When I visit the cities:
  <quotes>
  <origin>
  Amsterdam
  Brussels
  Copenhagen
  <destination>
  <quotes>
  """

  # Now use it...
  When I [make a long journey from "London" to "Oslo"]
