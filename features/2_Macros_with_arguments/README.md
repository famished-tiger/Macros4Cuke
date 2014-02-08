# Passing data values to a macro-step #

Macro-steps as defined in the _Basics_ section are pretty limited. 

Remember Joe and his calculator?...  
Suppose that Joe created a macro-step as follows:
```cucumber
    ...
    Given I define the step "When I [enter the number 8]" to mean:  
    """  
    When I type 8  
    And I click Enter 
    """
    ...
```

While being a perfectly valid macro, it is almost useless since it will always enter the same digit 8.

What Joe really needs is a macro-step that allows him to enter any number.  
His wish, in turn, implies that the previous macro-step should accept one parameter value: the number to enter.

Here is how Joe might proceed:
```cucumber
    ...
    Given I define the step "When I [enter the number <some_number>]" to mean:  
    """
    When I type <some_number>  
    And I click Enter 
    """
    ...
```

And here is how he can use the last macro to enter the value 2:

```cucumber
    ...
    When I [enter the number "2"] 
    ...
```

## Rules of the game ##
When a macro-step is required to take one or more values, then:

1. Place in the step being defined the name of an argument between chevrons < ... >.
2. When the macro is used in a scenario, place the value of the corresponding argument between double quotes "...".


