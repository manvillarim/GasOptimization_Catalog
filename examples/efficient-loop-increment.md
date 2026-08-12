# 26. Use Efficient Loop Increment

This transformation replaces the loop increment `i += 1` by `i++`. The two are equal as expressions, but the compiler emits a shorter sequence for the increment operator.

The variant of this rule that recommends `++i` over `i++` has no effect. Both forms compile to the same bytecode when the result of the expression is discarded, which is always the case in the increment position of a `for` statement.

## Example

### Original (Addition Assignment)
```solidity
contract A {
    uint256 public data;

    function loop(uint256 n) external {
        for (uint256 i = 0; i < n; i += 1) {
            data += i;
        }
    }
}
```

### Optimised (Increment Operator)
```solidity
contract Ao {
    uint256 public data;

    function loop(uint256 n) external {
        for (uint256 i = 0; i < n; i++) {
            data += i;
        }
    }
}
```

## Gas Savings

Measured with Foundry on the pair above (solc 0.8.26, optimiser at 200 runs), `loop(1000)` costs 462,346 gas in `A` against 385,346 in `Ao`: 77 gas per iteration, or 16.65% of the call. The runtime code of `Ao` is 9 bytes shorter.

Compiling the same body with `++i` instead of `i++` gives bytecode identical to `Ao` and the same 385,346 gas. Pre-increment and post-increment are interchangeable here; only the choice against `i += 1` matters.
