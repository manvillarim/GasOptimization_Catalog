# 9. Avoid Explicit Zero Initialization

This transformation removes the explicit initialisation of a variable with the zero value of its type. Solidity assigns that value anyway, so the initialiser is redundant.

## Example

### Original (Explicit Zero Initialization)
```solidity
contract A {
    uint256 public counter = 0;
    bool public flag = false;
    address public owner = address(0);

    function processArray(uint256[] memory data) public pure returns (uint256 sum) {
        for (uint256 i = 0; i < data.length; i++) {
            sum += data[i];
        }
    }
}
```

### Optimised (Default Initialization)
```solidity
contract Ao {
    uint256 public counter;
    bool public flag;
    address public owner;

    function processArray(uint256[] memory data) public pure returns (uint256 sum) {
        for (uint256 i; i < data.length; i++) {
            sum += data[i];
        }
    }
}
```

## Gas Savings

The saving is confined to the creation code and it is small. Compiled with solc 0.8.26 and the optimiser at 200 runs, the two contracts above produce byte-identical runtime code; only the constructor differs, by 19 bytes for the three state variables.

On the local variable the transformation is a no-op: `uint256 i = 0` and `uint256 i` compile to the same bytecode, since a local variable is zero-initialised either way. The rule pays only where the redundant initialiser is on a state variable, and it never affects execution cost.
