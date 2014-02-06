# A first example #
Let's assume that our friend Joe wants to test a basic calculator.  
Joe uses Cucumber with a generic library of user interface steps that
allows him to perform user actions like:
- Filling a text field,
- Pressing on a button,
- Clicking on a link,...


For instance, the Cucumber steps necessary to calculate the sum of 8 + 3 are:
```cucumber
    When I type 8  
    And I click Enter
    And I type 3  
    And I click Enter
    And I click Add
    Then I should see 11
```


What strikes Joe is that some step sequences are repeating again and again in
many of his scenarios. As an example Joe would like to replace the scenario fragment:
```cucumber
    When I type 8  
    And I click Enter
```

by something shorter like:
```cucumber
    When I enter the number 8
```

For a programmer familiar with Cucumber, Joe's wish is a piece of a cake to achieve.
Alas, while Joe is a terrific tester he has little programming experience. Accordingly,
he doesn't feel confident enough to program step definitions. Or maybe he isn't knowledgeable
in the API used by the calculator...

Luckily, Joe is rescued from despair and when he reads in the next paragraph how
to get rid of the infamous scenario fragment.
  

With __Macros4Cuke__, all Joe has to do to create his wished new macro-step is:

```cucumber
    ...
    Given I define the step "When I [enter the number <value>]" to mean:  
    """  
    When I type <value>  
    And I click Enter 
    """
    ...
```

Once this is done, then the original scenario above can be rewritten as follows:
```cucumber
    When I [enter the number "8"]
    And I [enter the number "3"]
    And I click Add
    Then I should see 11
```

No programming was required! The only price to pay are the step syntax conventions imposed by __Macros4Cuke__.
But this is really bargain compared to the added convenience.

With a little imagination, Joe could even reduce the last scenario to something like:
```cucumber
    When I [calculate the sum of "8" and "3"]
    Then I should see 11
```

Are you interested to reduce the length of your scenarios or do you want to use higher-level
steps that conceal the boring details without fiddling with step definition programming?...

Then proceed to the topics below.



  
