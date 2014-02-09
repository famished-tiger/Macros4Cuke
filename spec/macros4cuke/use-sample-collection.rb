# File: sample-collection.rb
# Purpose: mix-in module with helper methods to build a sample
# collection of macro-steps.

require_relative '../../lib/macros4cuke/macro-collection'

module Macros4Cuke # Open this namespace to avoid module qualifier prefixes

# Mix-in module.
# Defines a set of methods that builds for testing purposes
# a sample collection of macro-steps.
module UseSampleCollection
  # Phrase of first macro-step in the collection.
  SamplePhrase1 = 'enter my credentials as <userid>'

  # Sub-steps of the first macro-step in the collection.
  SampleSubsteps1 = begin
    snippet = <<-SNIPPET
  Given I landed in the homepage
  When I click "Sign in"
  And I fill in "Username" with "<userid>"
  And I fill in "Password" with "<password>"
  And I click "Submit"
SNIPPET

    snippet
  end

  # Phrase of second macro-step in the collection.
  SamplePhrase2 = 'fill in the form with'

  # Sub-steps of the second macro-step in the collection.
  SampleSubsteps2 = begin
    snippet = <<-SNIPPET
  When I fill in "first_name" with "<firstname>"
  And I fill in "last_name" with "<lastname>"
  And I fill in "street_address" with "<street_address>"
  And I fill in "zip" with "<postcode>"
  And I fill in "city" with "<city>"
  And I fill in "country" with "<country>"

  # Let's assume that the e-mail field is optional.
  # The step between the <?email>...<email> will be executed
  # when the argument <email> has a value assigned to it.
  <?email>
  And I fill in "email" with "<email>"
  </email>

  # Let's also assume that comment is also optional
  # See the slightly different syntax: the conditional section
  # <?comment>...<comment> may fit in a single line
<?comment>  And I fill in "comment" with "<comment>"</comment>
  And I click "Save"
SNIPPET
    snippet
  end

  # Helper. Stuff the macro collection with sample steps.
  def fill_collection()
    coll = MacroCollection.instance

    coll.clear  # Start from scratch: zap the existing macro-steps

    coll.add_macro(SamplePhrase1, SampleSubsteps1, true)
    coll.add_macro(SamplePhrase2, SampleSubsteps2, true)
  end


  # Helper. For convenience, provide a shorter name
  # for the macro-step collection.
  def macro_coll()
    return MacroCollection.instance
  end

end # module

end # module

# End of file
