# File: demo07.feature

Feature: Save all encountered macro-step definitions in a single file
  As a prolific macro-step writer
  So that I have an list of all macro-steps in a single place.


  Scenario: Listing all encountered macro-steps definitions
  
    # This step is bundled with Macro4Cuke as a convenience.
    # The file "all_macros.feature" is created and saved when Cucumber completes.
    # You should find the file in the folder where macros4cuke resides.
    # If you use this step in your own Cucumber project, 
    # then the file will be placed in the project's root folder.
    When I want to list all the macros in the file "all_macros.feature"