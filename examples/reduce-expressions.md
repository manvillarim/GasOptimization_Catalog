# 15. Reduce Mathematical Expressions

This transformation rewrites an expression into an equivalent one with fewer operations, by factorisation, by De Morgan's laws, or by removing a redundant computation.

## Example

### Original (Unreduced Expressions)
```solidity
contract A {
    function calculateLogic(bool x, bool y) public pure returns (bool) {
        return (!x) && (!y);
    }

    function processValues(uint256 a, uint256 b, uint256 c) public pure returns (uint256) {
        return (a * 2) + (b * 2) + (c * 2);
    }
}
```

### Optimised (Reduced Expressions)
```solidity
contract Ao {
    function calculateLogic(bool x, bool y) public pure returns (bool) {
        return !(x || y);
    }

    function processValues(uint256 a, uint256 b, uint256 c) public pure returns (uint256) {
        return 2 * (a + b + c);
    }
}
```

## Applicability

An algebraic identity over the integers is not automatically an identity under checked arithmetic, since the two forms may overflow on different intermediates. The factorisation above survives the check: an intermediate of the original overflows only when `2(a+b+c)` does not fit in 256 bits, and the same holds of the rewrite, so the two revert on exactly the same arguments. A rewrite for which this does not hold — cancelling a division against a multiplication, for instance — changes the failure behaviour and needs the arithmetic to be placed inside `unchecked`, where the identity holds over the ring of 256-bit words.

The boolean rewrite raises no such question, and `&&` and `||` both short-circuit, so the number of operands evaluated is unchanged.

## Gas Savings

Each operation removed is a few gas per call. The rule matters where the expression sits inside a loop or on a frequently taken path, and its effect is small elsewhere.
