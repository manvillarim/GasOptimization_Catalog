# 29. Use mappings instead of arrays for data lists

This transformation replaces arrays with mappings when iteration is not required. Mappings are more gas-efficient for storage and retrieval operations, especially when dealing with large datasets or when you need to access elements by key rather than iterating through all elements.

## Example

### Using Arrays (Less Efficient)
```solidity
contract ArrayContract {
   uint[] public numbers;
   
   function addNumber(uint _number) public {
       numbers.push(_number); // Dynamic array expansion costs gas
   }
   
   function getNumber(uint _index) public view returns(uint) {
       require(_index < numbers.length, "Index out of bounds");
       return numbers[_index]; // Array access
   }
   
   function updateNumber(uint _index, uint _newValue) public {
       require(_index < numbers.length, "Index out of bounds");
       numbers[_index] = _newValue; // Array modification
   }
   
   function removeNumber(uint _index) public {
       require(_index < numbers.length, "Index out of bounds");
       // Expensive operation: shifting all elements
       for(uint i = _index; i < numbers.length - 1; i++) {
           numbers[i] = numbers[i + 1];
       }
       numbers.pop();
   }
   
   function getTotalSum() public view returns(uint sum) {
       for(uint i = 0; i < numbers.length; i++) {
           sum += numbers[i]; // Iteration possible but expensive
       }
   }
}
```

### Using Mappings (More Efficient)
```solidity
contract MappingContract {
    mapping(uint => uint) public numbers;
    uint public size;
    
    function addNumber(uint _number) public {
        numbers[size] = _number; // Direct mapping assignment
        size++; // Track size manually
    }
    
    function getNumber(uint _index) public view returns(uint) {
        return numbers[_index]; // Direct mapping access - no bounds check needed
    }
    
    function updateNumber(uint _index, uint _newValue) public {
        numbers[_index] = _newValue; // Direct mapping modification
    }
    
    function removeNumber(uint _index) public {
        delete numbers[_index]; // Efficient deletion without shifting
        // Note: This creates gaps in the sequence
    }
    
    function getSize() public view returns(uint) {
        return size;
    }
    
    // Alternative: Use mapping with existence tracking
    mapping(uint => bool) public exists;
    
    function addNumberWithTracking(uint _number) public {
        numbers[size] = _number;
        exists[size] = true; // Track existence
        size++;
    }
    
    function removeNumberWithTracking(uint _index) public {
        delete numbers[_index];
        exists[_index] = false; // Mark as non-existent
    }
}
```