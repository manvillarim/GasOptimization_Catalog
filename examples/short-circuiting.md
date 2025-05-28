# 17. Use short-circuiting for conditional expressions

This transformation leverages Solidity's short-circuit evaluation for logical operators. In expressions with AND (&&) and OR (||) operators, the second operand is only evaluated if necessary, potentially saving gas by avoiding unnecessary computations.

## Example

### Without Short-Circuiting Optimization
```solidity
contract NoShortCircuit {
    mapping(address => uint) public balances;
    
    function expensiveCheck(address user) private view returns(bool) {
        // Simulate expensive operation
        uint balance = balances[user];
        return balance > 1000;
    }
    
    function validateUser(address user) public view returns(bool) {
        bool isValid = false;
        bool hasBalance = expensiveCheck(user); // Always executed
        
        if(user != address(0) && hasBalance) {
            isValid = true;
        }
        return isValid;
    }
}
```
### With Short-Circuiting Optimization

```solidity
contract WithShortCircuit {
    mapping(address => uint) public balances;
    
    function expensiveCheck(address user) private view returns(bool) {
        // Simulate expensive operation
        uint balance = balances[user];
        return balance > 1000;
    }
    
    function validateUser(address user) public view returns(bool) {
        // Short-circuit: expensiveCheck only called if user != address(0)
        return user != address(0) && expensiveCheck(user);
    }
}
```