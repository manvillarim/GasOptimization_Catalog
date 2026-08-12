# 6. State Variable Packing

This transformation reorders the declarations of the state variables so that those narrower than a word share a slot. Solidity assigns slots in declaration order and starts a new slot whenever the next variable does not fit in what remains of the current one, so a wide variable placed between two narrow ones wastes the space beside each of them.

## Example

### Original (Unpacked Layout)
```solidity
contract A {
    uint128 private a;   // slot 0, bytes 0-15
    uint256 private b;   // slot 1
    uint128 private c;   // slot 2, bytes 0-15

    function update(uint128 newA, uint128 newC) external {
        a = newA;
        c = newC;
    }

    function sumNarrow() external view returns (uint256) {
        return uint256(a) + uint256(c);
    }
}
```

### Optimised (Packed Layout)
```solidity
contract Ao {
    uint128 private a;   // slot 0, bytes 0-15
    uint128 private c;   // slot 0, bytes 16-31
    uint256 private b;   // slot 1

    function update(uint128 newA, uint128 newC) external {
        a = newA;
        c = newC;
    }

    function sumNarrow() external view returns (uint256) {
        return uint256(a) + uint256(c);
    }
}
```

## Applicability

The reordering changes the storage layout without changing the interface, so the coupling invariant relates the two contracts variable by variable and not slot by slot. That also means the rule cannot be applied to an implementation sitting behind a proxy whose storage is already in use, since the existing state would be reinterpreted under the new layout.

Packing pays only when the variables sharing a slot are used together. Two variables in the same slot are read with a single SLOAD, but they are also written with a read-modify-write of that slot: a function that writes only `a` now pays to preserve `c`. Where the narrow variables are touched by different transactions, the unpacked layout can be the cheaper one.

## Gas Savings

The contract uses two slots instead of three, which the constructor pays for once, and `update` and `sumNarrow` reach both narrow variables through a single slot instead of two.
