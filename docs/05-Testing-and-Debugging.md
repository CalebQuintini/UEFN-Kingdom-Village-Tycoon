# Testing and Debugging

## Overview

Kingdom Village Tycoon was primarily tested through manual gameplay sessions launched from Unreal Editor for Fortnite (UEFN).

During development, Verse's `Print()` function was used to output debugging information and verify the execution of gameplay logic.

This approach helped identify whether player interactions triggered the expected functions and whether conditional checks executed their intended success or failure paths.

## Debugging Approach

The general debugging process involved:

1. Identifying the gameplay mechanic or function being tested.
2. Adding temporary `Print()` statements to relevant sections of the Verse code.
3. Building the Verse code and launching a UEFN play session.
4. Interacting with the relevant gameplay device.
5. Examining the printed output to determine which execution path was taken.
6. Adjusting the code when the observed behavior differed from the expected result.
7. Repeating the test to verify the change.

## Example: Purchase Validation

When testing the building purchase system, debug messages can be used to determine whether the currency validation succeeds or fails.

For example:

```verse
if:
    PlayersGold >= Price
then:
    Print("Purchase successful")
else:
    Print("Insufficient currency")
```

Testing the purchase interaction with different currency balances allows the success and failure conditions to be examined.

## Manual Gameplay Verification

In addition to debug messages, gameplay behavior can be observed directly during playtesting.

For example, a successful building purchase should result in the appropriate structure being revealed and the player's available currency being updated.

## Limitations

Testing has primarily relied on manual gameplay interactions and debug output rather than an automated test suite.

While this approach is useful for validating individual gameplay interactions, additional testing would be beneficial for scenarios involving multiple simultaneous players, persistence across sessions, and repeated interactions.
