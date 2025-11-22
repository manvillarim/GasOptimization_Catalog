# 16. Use Short-Circuiting for Conditional Expressions

This transformation leverages Solidity's short-circuit evaluation for logical operators (`&&` and `||`). The evaluation stops as soon as the result is determined: for `&&`, if the first operand is false, the second is not evaluated; for `||`, if the first is true, the second is skipped. By placing cheaper or more likely conditions first, expensive operations can be avoided when unnecessary.

## Example

### Original (No Short-Circuit Optimization)
```solidity
contract NoShortCircuit {
    mapping(address => uint) public balances;
    
    function expensiveCheck(address user) private view returns (bool) {
        // Expensive operation
        return balances[user] > 1000;
    }
    
    function validateUser(address user) public view returns (bool) {
        bool hasBalance = expensiveCheck(user);  // Always executed
        bool validAddress = user != address(0);
        return validAddress && hasBalance;
    }
}
```

### Optimised (Short-Circuit Aware)
```solidity
contract WithShortCircuit {
    mapping(address => uint) public balances;
    
    function expensiveCheck(address user) private view returns (bool) {
        // Expensive operation
        return balances[user] > 1000;
    }
    
    function validateUser(address user) public view returns (bool) {
        // Cheap check first: expensiveCheck skipped if user == address(0)
        return user != address(0) && expensiveCheck(user);
    }
}
```

## Gas Savings

Ordering conditions to take advantage of short-circuit evaluation reduces gas consumption by preventing unnecessary execution of expensive operations when earlier conditions already determine the final result.