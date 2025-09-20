// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * Contract Ao - Using Mappings for Storage Optimization
 * This contract demonstrates the use of mappings instead of arrays
 * which is more gas-efficient for storage and retrieval operations
 */
contract Ao {
    // Mapping storage (OPTIMIZED)
    mapping(uint256 => uint256) public values;
    mapping(uint256 => bool) public exists; // Track existence
    uint256 public nextIndex; // Next available index
    
    // State tracking (same as A for equivalence)
    uint256 public totalSum;
    uint256 public elementCount;
    uint256 public lastAdded;
    uint256 public lastRemoved;
    uint256 public operationCount;
    
    // Events (same as A)
    event ValueAdded(uint256 indexed index, uint256 value);
    event ValueUpdated(uint256 indexed index, uint256 oldValue, uint256 newValue);
    event ValueRemoved(uint256 indexed index, uint256 value);
    
    // Add a new value to the mapping (OPTIMIZED)
    function addValue(uint256 _value) external returns (uint256 index) {
        index = nextIndex;
        values[index] = _value; // Direct mapping assignment
        exists[index] = true;
        nextIndex++;
        
        totalSum += _value;
        elementCount++;
        lastAdded = _value;
        operationCount++;
        
        emit ValueAdded(index, _value);
    }
    
    // Get value at specific index (OPTIMIZED)
    function getValue(uint256 _index) external view returns (uint256) {
        require(exists[_index], "Index out of bounds");
        return values[_index]; // Direct mapping access
    }
    
    // Update value at specific index (OPTIMIZED)
    function updateValue(uint256 _index, uint256 _newValue) external {
        require(exists[_index], "Index out of bounds");
        
        uint256 oldValue = values[_index];
        values[_index] = _newValue; // Direct mapping update
        
        // Update totalSum
        totalSum = totalSum - oldValue + _newValue;
        operationCount++;
        
        emit ValueUpdated(_index, oldValue, _newValue);
    }
    
    // Remove value at specific index (OPTIMIZED - no shifting needed!)
    function removeValue(uint256 _index) external {
        require(exists[_index], "Index out of bounds");
        
        uint256 removedValue = values[_index];
        
        // Simply delete the mapping entry (much more efficient!)
        delete values[_index];
        exists[_index] = false;
        
        totalSum -= removedValue;
        elementCount--;
        lastRemoved = removedValue;
        operationCount++;
        
        emit ValueRemoved(_index, removedValue);
    }
    
    // Get effective length (number of elements)
    function getLength() external view returns (uint256) {
        return elementCount; // Return count of existing elements
    }
    
    // Check if a value exists (requires iteration through mapping)
    function containsValue(uint256 _value) external view returns (bool) {
        // Note: This is less efficient with mappings as we need to check all indices
        for (uint256 i = 0; i < nextIndex; i++) {
            if (exists[i] && values[i] == _value) {
                return true;
            }
        }
        return false;
    }
    
    // Get sum of range
    function getRangeSum(uint256 _start, uint256 _end) external view returns (uint256 sum) {
        require(_start <= _end && _end < nextIndex, "Invalid range");
        
        for (uint256 i = _start; i <= _end; i++) {
            if (exists[i]) {
                sum += values[i];
            }
        }
    }
    
    // Find index of value
    function indexOf(uint256 _value) external view returns (uint256) {
        for (uint256 i = 0; i < nextIndex; i++) {
            if (exists[i] && values[i] == _value) {
                return i;
            }
        }
        revert("Value not found");
    }
    
    // Batch add values (OPTIMIZED)
    function batchAdd(uint256[] calldata _values) external {
        uint256 startIndex = nextIndex;
        
        for (uint256 i = 0; i < _values.length; i++) {
            values[startIndex + i] = _values[i];
            exists[startIndex + i] = true;
            totalSum += _values[i];
            elementCount++;
        }
        
        if (_values.length > 0) {
            lastAdded = _values[_values.length - 1];
            operationCount += _values.length;
            nextIndex += _values.length;
        }
    }
    
    // Clear all values
    function clear() external {
        // Reset all state variables
        for (uint256 i = 0; i < nextIndex; i++) {
            if (exists[i]) {
                delete values[i];
                exists[i] = false;
            }
        }
        
        nextIndex = 0;
        totalSum = 0;
        elementCount = 0;
        operationCount++;
    }
    
    // Get current state (matching A's interface)
    function getState() external view returns (
        uint256 _totalSum,
        uint256 _elementCount,
        uint256 _lastAdded,
        uint256 _lastRemoved,
        uint256 _operationCount,
        uint256 _effectiveLength
    ) {
        return (totalSum, elementCount, lastAdded, lastRemoved, operationCount, elementCount);
    }
}