# 29. Use mappings instead of arrays for data lists

This transformation replaces arrays with mappings when iteration is not required. Mappings are more gas-efficient for storage and retrieval operations, especially when dealing with large datasets or when you need to access elements by key rather than iterating through all elements.

## Example

### Using Arrays (Less Efficient)
```solidity
contract ArrayContract {
    uint[] public numbers;
    
    function addNumber(uint _number) public {
        numbers.push(_number);
    }
    
    function getNumber(uint _index) public view returns(uint) {
        require(_index < numbers.length, "Index out of bounds");
        return numbers[_index];
    }
    
    function updateNumber(uint _index, uint _newValue) public {
        require(_index < numbers.length, "Index out of bounds");
        numbers[_index] = _newValue;
    }
    
    function removeNumber(uint _index) public {
        require(_index < numbers.length, "Index out of bounds");
        for(uint i = _index; i < numbers.length - 1; i++) {
            numbers[i] = numbers[i + 1];
        }
        numbers.pop();
    }
    
    function getTotalSum() public view returns(uint sum) {
        for(uint i = 0; i < numbers.length; i++) {
            sum += numbers[i];
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
        numbers[size] = _number;
        size++;
    }
    
    function getNumber(uint _index) public view returns(uint) {
        require(_index < size, "Index out of bounds");
        return numbers[_index];
    }
    
    function updateNumber(uint _index, uint _newValue) public {
        require(_index < size, "Index out of bounds");
        numbers[_index] = _newValue;
    }
    
    function removeNumber(uint _index) public {
        require(_index < size, "Index out of bounds");
        for(uint i = _index; i < size - 1; i++) {
            numbers[i] = numbers[i + 1];
        }
        delete numbers[size - 1];
        size--;
    }
    
    function getTotalSum() public view returns(uint sum) {
        for(uint i = 0; i < size; i++) {
            sum += numbers[i];
        }
    }
}
```