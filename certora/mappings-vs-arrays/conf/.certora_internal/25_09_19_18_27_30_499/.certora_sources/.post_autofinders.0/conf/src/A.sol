// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * Contract A - Using Arrays for Storage
 * This contract demonstrates the use of arrays for data storage
 * which requires more gas for operations like deletion and can be less efficient
 */
contract A {
    // Array storage
    uint256[] public values;
    
    // State tracking
    uint256 public totalSum;
    uint256 public elementCount;
    uint256 public lastAdded;
    uint256 public lastRemoved;
    uint256 public operationCount;
    
    // Events
    event ValueAdded(uint256 indexed index, uint256 value);
    event ValueUpdated(uint256 indexed index, uint256 oldValue, uint256 newValue);
    event ValueRemoved(uint256 indexed index, uint256 value);
    
    // Add a new value to the array
    function addValue(uint256 _value) external returns (uint256 index) {
        index = values.length;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000003,index)}
        values.push(_value); // Dynamic array expansion
        
        totalSum += _value;
        elementCount++;
        lastAdded = _value;
        operationCount++;
        
        emit ValueAdded(index, _value);
    }
    
    // Get value at specific index
    function getValue(uint256 _index) external view returns (uint256) {
        require(_index < values.length, "Index out of bounds");
        return values[_index];
    }
    
    // Update value at specific index
    function updateValue(uint256 _index, uint256 _newValue) external {
        require(_index < values.length, "Index out of bounds");
        
        uint256 oldValue = values[_index];assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000001,oldValue)}
        values[_index] = _newValue;
        
        // Update totalSum
        totalSum = totalSum - oldValue + _newValue;
        operationCount++;
        
        emit ValueUpdated(_index, oldValue, _newValue);
    }
    
    // Remove value at specific index (expensive operation)
    function removeValue(uint256 _index) external {
        require(_index < values.length, "Index out of bounds");
        
        uint256 removedValue = values[_index];assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000002,removedValue)}
        
        // Shift all elements after index (expensive!)
        for (uint256 i = _index; i < values.length - 1; i++) {
            values[i] = values[i + 1];
        }
        values.pop();
        
        totalSum -= removedValue;
        elementCount--;
        lastRemoved = removedValue;
        operationCount++;
        
        emit ValueRemoved(_index, removedValue);
    }
    
    // Get array length
    function getLength() external view returns (uint256) {
        return values.length;
    }
    
    // Check if a value exists in the array (requires iteration)
    function containsValue(uint256 _value) external view returns (bool) {
        for (uint256 i = 0; i < values.length; i++) {
            if (values[i] == _value) {
                return true;
            }
        }
        return false;
    }
    
    // Get sum of range (can iterate)
    function getRangeSum(uint256 _start, uint256 _end) external view returns (uint256 sum) {
        require(_start <= _end && _end < values.length, "Invalid range");
        
        for (uint256 i = _start; i <= _end; i++) {
            sum += values[i];assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000004,sum)}
        }
    }
    
    // Find index of value (requires iteration)
    function indexOf(uint256 _value) external view returns (uint256) {
        for (uint256 i = 0; i < values.length; i++) {
            if (values[i] == _value) {
                return i;
            }
        }
        revert("Value not found");
    }
    
    // Batch add values
    function batchAdd(uint256[] calldata _values) external {
        for (uint256 i = 0; i < _values.length; i++) {
            values.push(_values[i]);
            totalSum += _values[i];
            elementCount++;
        }
        
        if (_values.length > 0) {
            lastAdded = _values[_values.length - 1];
            operationCount += _values.length;
        }
    }
    
    // Clear all values
    function clear() external {
        delete values; // Deletes the entire array
        totalSum = 0;
        elementCount = 0;
        operationCount++;
    }
    
    // Get current state
    function getState() external view returns (
        uint256 _totalSum,
        uint256 _elementCount,
        uint256 _lastAdded,
        uint256 _lastRemoved,
        uint256 _operationCount,
        uint256 _arrayLength
    ) {
        return (totalSum, elementCount, lastAdded, lastRemoved, operationCount, values.length);
    }
}