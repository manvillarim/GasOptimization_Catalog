# 16. Use Short-Circuiting for Conditional Expressions

This transformation orders the operands of `&&` and `||` so that the cheap one is evaluated first. Solidity short-circuits both operators: for `&&` the second operand is not evaluated when the first is false, and for `||` it is not evaluated when the first is true. Writing the condition that decides the result most often, and costs least, on the left avoids the other.

## Example

### Original (Expensive Operand Evaluated First)
```solidity
contract A {
    mapping(address => uint256) private balances;

    function hasBalance(address user) private view returns (bool) {
        return balances[user] > 1000;
    }

    function validateUser(address user) public view returns (bool) {
        bool funded = hasBalance(user);
        return user != address(0) && funded;
    }
}
```

### Optimised (Cheap Operand First)
```solidity
contract Ao {
    mapping(address => uint256) private balances;

    function hasBalance(address user) private view returns (bool) {
        return balances[user] > 1000;
    }

    function validateUser(address user) public view returns (bool) {
        return user != address(0) && hasBalance(user);
    }
}
```

## Applicability

The operand that may now be skipped must be free of side effects and must not revert. `hasBalance` only reads a mapping, so skipping it changes nothing beyond the gas. An operand that writes state, emits an event, calls out, or can revert — a division whose divisor may be zero, for instance — is not interchangeable: the original evaluates it on every call and the rewrite does not, and the two contracts then differ on the inputs that make the first operand false.

Reordering the operands of the same expression carries the same condition, and additionally requires the two conditions to be independent, so that neither is what makes the other well defined.

## Gas Savings

The saving is the cost of the operand avoided, weighted by how often the first operand decides the result. It is largest when the skipped operand reads storage or calls another contract.
