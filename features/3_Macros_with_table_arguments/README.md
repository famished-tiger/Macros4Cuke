# Passing values to a macro-step through a table #

## Learned so far ##

We discovered in the previous sections how to:
- Create a macro-step, and
- Pass data values to it.

As a further, example, here is the of a macro-step that takes three arguments such as:
```cucumber
    Given I define the step "When I [fly from <origin> to <destination> via <stopover>]" to mean:
    """
    When I take-off from <origin>  
    And I land in <stopover>
    And I take-off from <stopover>
    And I land in <destination>
    """
```

Our macro-step can be used in a scenario like this:

```cucumber
    ...
    When I [fly from "Copenhagen" to "Milan" via "Paris"]
    ...
```

The text between double quotes, such as "Milan" are data values that the macro
will use when it executes its own sub-steps.

## Using a table to pass data to a macro-step ##

While the use of macro-steps parameters is rather straightforward, it is however not always
very practical in situations when:
- A lot of arguments (say, more than 4) must be passed; or,
- Some arguments take long text values.

In these cases, with the approach described above we end up with steps that are 
very long and hard to follow.

Therefore, __Macros4Cuke__ provides an alternative step syntax that allows you to pass
data values through a table.

The syntax for the macro definition is almost the same as above

```cucumber
    Given I define the step "When I [fly to <destination>]:" to mean:
    """
    When I take-off from <from>  
    And I land in <via>
    And I take-off from <via>
    And I land in <destination>
    """
```

Did you spot the key difference? There is a colon ':' character right after the closing bracket ']'.
It is this colon character that tells __Macros4Cuke__ that some arguments will be passed via a table.
Also some argument names were changed in order to make the syntax of a call to the macro-step more natural.

The syntax to call the macro with a table of arguments is as follows:
```cucumber
    When I [fly to "Milan"]:
    |from |Copenhague|
    |via  |Paris     |
```

There are three argument values. The first one "Milan" is passed directly in the step sentence.
The two others are passed via a table.

## Rules of the game ##
Here are the conventions to apply when a macro-step is required to take values via a table.
In the macro definition:
1. Add a colon ':' just after the closing square bracket.
2. You are allowed to pass also arguments in the step sentence.

When calling the macro:
3. The table used to pass arguments must have exactly two columns.
4. The first column contains the argument names.
5. The second column contains the argument values.
6. A row consists of a pair argument name - its value

 






