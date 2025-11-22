# 17. Write Values Directly Instead of Calculating

This transformation replaces compile-time calculable expressions with their pre-computed literal values. While Solidity's optimizer can handle many constant expressions, writing values directly eliminates any potential overhead and makes the code's intent clearer. This is particularly effective for complex expressions or when defining constants that will be used throughout the contract.

## Example

### Original (Runtime/Compile-time Calculations)
```solidity
contract RuntimeCalc {
    uint public constant SECONDS_IN_DAY = 24 * 60 * 60;
    uint public constant WEI_IN_ETHER = 10 ** 18;
    uint public constant BASIS_POINTS = 100 * 100;
    
    function getWeekHours() public pure returns (uint) {
        return 7 * 24;  // Expression evaluated
    }
}
```

### Optimised (Pre-computed Values)
```solidity
contract PrecomputedValues {
    uint public constant SECONDS_IN_DAY = 86400;      // Pre-computed
    uint public constant WEI_IN_ETHER = 1000000000000000000;  // Pre-computed
    uint public constant BASIS_POINTS = 10000;        // Pre-computed
    
    function getWeekHours() public pure returns (uint) {
        return 168;  // Direct value
    }
}
```

## Gas Savings

Writing pre-computed values directly eliminates any potential compilation or runtime overhead from evaluating expressions, ensuring the most efficient bytecode regardless of optimizer settings.