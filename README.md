# TimeContract
A time based contract that transfers control from a "parent/owner" address to a "child" address if a "check in" deadline is missed.
It builds on work from the CrowdFund contract.

UPDATES TO COME:
* Restricts child address to withdrawing a specific amount.
* Allows child address to send an "Emergency" check in.
* Allows parent address to dynamically add more than one "child" (children) addresses as well as an option to remove one or more child (children) addresses.
* Grants parent address option to have child account withdrawal limit increase over after a specified period.
