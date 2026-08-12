# 20. Limit Number of Modifiers

This transformation moves the body of a modifier into an internal function. A modifier is inlined at every function that carries it, so its code is duplicated once per use; an internal function is emitted once and reached by a jump.

## Example

### Original (Checks in Modifiers)
```solidity
contract A {
    address public owner;
    bool public paused;
    mapping(address => bool) public authorized;

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    modifier notPaused() {
        require(!paused, "Contract paused");
        _;
    }

    modifier onlyAuthorized() {
        require(authorized[msg.sender], "Not authorized");
        _;
    }

    function transfer(address target) public onlyOwner notPaused onlyAuthorized {
        // body
    }

    function withdraw(address target) public onlyOwner notPaused onlyAuthorized {
        // body
    }
}
```

### Optimised (Checks in an Internal Function)
```solidity
contract Ao {
    address public owner;
    bool public paused;
    mapping(address => bool) public authorized;

    function validateAccess() internal view {
        require(msg.sender == owner, "Not owner");
        require(!paused, "Contract paused");
        require(authorized[msg.sender], "Not authorized");
    }

    function transfer(address target) public {
        validateAccess();
        // body
    }

    function withdraw(address target) public {
        validateAccess();
        // body
    }
}
```

## Applicability

The checks must keep their order. Modifiers run in the order they are written, before the body, so `validateAccess` has to test ownership, then the paused flag, then the authorisation, and to carry the same revert strings. Reordering them changes which message a caller receives, and changes behaviour outright if one check guards a state the next one reads.

A modifier that wraps the body rather than only preceding it — one with code after the `_;`, as a reentrancy guard has — cannot be replaced by a single call and falls outside the rule.

## Gas Savings

The saving is in deployment size, and it grows with the number of functions carrying the modifiers: three modifiers inlined into two functions become one copy of the three checks. Runtime cost is essentially unchanged, the inlined sequence being replaced by a jump to the same checks.
