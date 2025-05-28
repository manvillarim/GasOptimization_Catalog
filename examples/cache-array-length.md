# 27. Cache array length in loops

This transformation caches the array length in a local variable before loop execution. Accessing the length property of arrays incurs gas costs, and when done repeatedly in loop conditions, it can significantly increase gas consumption.

## Example

### Array Length Access in Loop
```solidity
contract ArrayLengthInLoop {
    uint[] public numbers;
    address[] public users;
    
    function processNumbers() public {
        // Array length accessed in every iteration
        for(uint i = 0; i < numbers.length; i++) {
            numbers[i] = numbers[i] * 2;
        }
    }
    
    function findUser(address target) public view returns(bool found) {
        // Array length accessed in every iteration check
        for(uint i = 0; i < users.length; i++) {
            if(users[i] == target) {
                return true;
            }
        }
        return false;
    }
    
    function processMultipleArrays() public {
        // Multiple arrays with length access
        for(uint i = 0; i < numbers.length && i < users.length; i++) {
            // Process both arrays
        }
    }
}
```

### Optimized Cached Array Length
```solidity
contract CachedArrayLength {
    uint[] public numbers;
    address[] public users;
    
    function processNumbers() public {
        // Cache array length once
        uint length = numbers.length;
        for(uint i = 0; i < length; i++) {
            numbers[i] = numbers[i] * 2;
        }
    }
    
    function findUser(address target) public view returns(bool found) {
        // Cache array length once
        uint length = users.length;
        for(uint i = 0; i < length; i++) {
            if(users[i] == target) {
                return true;
            }
        }
        return false;
    }
    
    function processMultipleArrays() public {
        // Cache both array lengths
        uint numbersLength = numbers.length;
        uint usersLength = users.length;
        uint minLength = numbersLength < usersLength ? numbersLength : usersLength;
        
        for(uint i = 0; i < minLength; i++) {
            // Process both arrays
        }
    }
}
```