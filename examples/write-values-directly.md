# 17. Write Values Directly Instead of Calculating

This transformation replaces an expression over literals by the literal it denotes.

It saves nothing. Solidity evaluates constant expressions at compile time, so `24 * 60 * 60` and `86400` reach the bytecode as the same value. Compiled with solc 0.8.26, the two contracts below produce byte-identical runtime code, with the optimiser at 200 runs and with the optimiser disabled alike. This entry is kept in the catalogue because the rule is published, and it is recorded here as having no effect rather than as an optimisation.

## Example

### Original (Constant Expressions)
```solidity
contract A {
    uint256 public constant SECONDS_IN_DAY = 24 * 60 * 60;
    uint256 public constant WEI_IN_ETHER = 10 ** 18;

    function getWeekHours() public pure returns (uint256) {
        return 7 * 24;
    }
}
```

### Optimised (Literals)
```solidity
contract Ao {
    uint256 public constant SECONDS_IN_DAY = 86400;
    uint256 public constant WEI_IN_ETHER = 1000000000000000000;

    function getWeekHours() public pure returns (uint256) {
        return 168;
    }
}
```

## Applicability

Constant folding requires the operands to be known at compile time. An expression mixing a literal with a `constant` is folded as well, since a `constant` is substituted before folding; one that reads an `immutable` or a state variable is not, and it is not an instance of this rule.

## Gas Savings

None, at deployment or at runtime. The expression is worth writing out only where the literal is clearer than the computation that produces it, which for `24 * 60 * 60` it is not.
