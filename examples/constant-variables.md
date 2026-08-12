# 13. Use Constant Variables for Unchanging Values

This transformation declares as `constant` a state variable that is never assigned after its initialisation. A `constant` occupies no storage slot: the compiler substitutes its value at every use, so the reads become push operations instead of SLOADs, and the constructor no longer writes the slot.

## Example

### Original (Regular State Variables)
```solidity
contract A {
    uint256 public maxSupply = 1000000;
    uint256 public mintingFee = 0.001 ether;
    bool public isPaused;

    function checkLimits(uint256 amount) public view returns (bool) {
        return amount <= maxSupply && !isPaused;
    }

    function calculateFees(uint256 amount) public view returns (uint256) {
        if (amount > maxSupply) {
            return mintingFee * 2;
        }
        return mintingFee;
    }
}
```

### Optimised (Constant Variables)
```solidity
contract Ao {
    uint256 public constant maxSupply = 1000000;
    uint256 public constant mintingFee = 0.001 ether;
    bool public isPaused;

    function checkLimits(uint256 amount) public view returns (bool) {
        return amount <= maxSupply && !isPaused;
    }

    function calculateFees(uint256 amount) public pure returns (uint256) {
        if (amount > maxSupply) {
            return mintingFee * 2;
        }
        return mintingFee;
    }
}
```

## Applicability

The names are kept as they are. Renaming `maxSupply` to `MAX_SUPPLY` to follow the usual convention for constants would rename the automatic getter as well, changing its selector, and a caller of the original contract would no longer reach it. The transformation must leave every public name untouched.

Two further points do not break the correspondence. A function that no longer reads storage may be declared `pure` instead of `view`; the selector is unchanged and both remain callable through `STATICCALL`. And removing a slot from the layout shifts the slots of the variables declared after it, which is invisible from outside but does mean that a coupling invariant must relate the two contracts field by field, and that the rule cannot be applied to a contract behind a proxy whose layout is already deployed.

## Gas Savings

Each read of the value becomes a push of a literal instead of an SLOAD, and the constructor no longer pays the write that initialised the slot. The runtime saving is proportional to how often the value is read.
