# 18. Write values directly instead of calculating

This transformation replaces runtime calculations with pre-computed constant values. Instead of performing calculations during contract execution, values are computed at compile time and written directly into the code, saving gas on arithmetic operations.

## Example

### Runtime Calculations
```solidity
contract RuntimeCalc {
    uint public constant SECONDS_IN_DAY = 24 * 60 * 60; // Calculated at runtime
    uint public constant WEI_IN_ETHER = 10 ** 18;       // Calculated at runtime
    
    function getTimeConstants() public pure returns(uint, uint) {
        uint hoursInWeek = 7 * 24;           // Runtime calculation
        uint minutesInHour = 60;             // Could be optimized
        return (hoursInWeek, minutesInHour);
    }
    
    function calculateFee(uint amount) public pure returns(uint) {
        return amount * 5 / 100; // Runtime division
    }
}
```
### Optimized Pre-computed Values

```solidity
contract PrecomputedValues {
    uint public constant SECONDS_IN_DAY = 86400;  // Pre-computed: 24 * 60 * 60
    uint public constant WEI_IN_ETHER = 1000000000000000000; // Pre-computed: 10^18
    
    function getTimeConstants() public pure returns(uint, uint) {
        uint hoursInWeek = 168;  // Pre-computed: 7 * 24
        uint minutesInHour = 60; // Direct value
        return (hoursInWeek, minutesInHour);
    }
    
    function calculateFee(uint amount) public pure returns(uint) {
        return amount * 5 / 100; // Keep as is - simple operation
    }
}
```