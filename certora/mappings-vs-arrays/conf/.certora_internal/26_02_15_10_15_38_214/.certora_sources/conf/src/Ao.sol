// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * Contract Ao - Mapping-based Implementation with Array Semantics
 * Optimized storage using mapping while maintaining array-like behavior
 */
contract Ao {
    // Mapping storage for values
    mapping(uint256 => uint256) public values;
    
    // Size counter (replaces array.length)
    uint256 public size;
    
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
    
    // Add a new value
    function addValue(uint256 _value) external returns (uint256 index) {
        index = size;
        values[size] = _value;
        unchecked{size++;}
        
        totalSum += _value;
        elementCount++;
        lastAdded = _value;
        operationCount++;
        
        emit ValueAdded(index, _value);
    }
    
    // Get value at specific index
    function getValue(uint256 _index) external view returns (uint256) {
        require(_index < size, "Index out of bounds");
        return values[_index];
    }
    
    // Update value at specific index
    function updateValue(uint256 _index, uint256 _newValue) external {
        require(_index < size, "Index out of bounds");
        
        uint256 oldValue = values[_index];
        values[_index] = _newValue;
        
        totalSum = totalSum - oldValue + _newValue;
        operationCount++;
        
        emit ValueUpdated(_index, oldValue, _newValue);
    }
    
    // Remove value at specific index (shift elements in mapping)
    function removeValue(uint256 _index) external {
        require(_index < size, "Index out of bounds");
        
        uint256 removedValue = values[_index];
        
        // Shift all elements after _index one position left in the mapping
        for (uint256 i = _index; i < size - 1; i++) {
            values[i] = values[i + 1];
        }
        delete values[size - 1];
        size--;
        
        totalSum -= removedValue;
        elementCount--;
        lastRemoved = removedValue;
        operationCount++;
        
        emit ValueRemoved(_index, removedValue);
    }
    
    // Get length
    function getLength() external view returns (uint256) {
        return size;
    }
    
    // Check if value exists
    function containsValue(uint256 _value) external view returns (bool) {
        for (uint256 i = 0; i < size; i++) {
            if (values[i] == _value) {
                return true;
            }
        }
        return false;
    }
    
    // Get sum of range
    function getRangeSum(uint256 _start, uint256 _end) external view returns (uint256 sum) {
        require(_start <= _end && _end < size, "Invalid range");
        
        for (uint256 i = _start; i <= _end; i++) {
            sum += values[i];
        }
    }
    
    // Find index of value
    function indexOf(uint256 _value) external view returns (uint256) {
        for (uint256 i = 0; i < size; i++) {
            if (values[i] == _value) {
                return i;
            }
        }
        revert("Value not found");
    }
    
    // Batch add values
    function batchAdd(uint256[] calldata _values) external {
        for (uint256 i = 0; i < _values.length; i++) {
            values[size] = _values[i];
            unchecked{size++;}
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
        for (uint256 i = 0; i < size; i++) {
            delete values[i];
        }
        size = 0;
        
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
        return (totalSum, elementCount, lastAdded, lastRemoved, operationCount, size);
    }
    
    // Helper to check if index exists
    function exists(uint256 _index) external view returns (bool) {
        return _index < size;
    }
    
    // Get storage index (for compatibility with A)
    function getStorageIndex(uint256 _logicalIndex) external view returns (uint256) {
        require(_logicalIndex < size, "Index out of bounds");
        return _logicalIndex; // In mapping, logical index = storage index
    }
}