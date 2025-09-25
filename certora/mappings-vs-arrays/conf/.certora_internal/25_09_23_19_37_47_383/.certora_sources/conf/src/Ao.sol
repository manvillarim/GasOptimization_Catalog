// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * Contract Ao - Optimized with Array-like Semantics
 * This version maintains EXACT equivalence with contract A while optimizing storage
 * Same functions, same behavior, just more gas efficient
 */
contract Ao {
    // Mapping storage for values (replaces uint256[] public values)
    mapping(uint256 => uint256) public values;
    
    // Packed state to save storage slots
    struct State {
        uint128 length;        // Replaces values.length
        uint128 elementCount;  // Active elements (same as A.elementCount)
    }
    State private state;
    
    // State tracking (exactly same as A)
    uint256 public totalSum;
    uint256 public lastAdded;
    uint256 public lastRemoved;
    uint256 public operationCount;
    
    // Events (exactly same as A)
    event ValueAdded(uint256 indexed index, uint256 value);
    event ValueUpdated(uint256 indexed index, uint256 oldValue, uint256 newValue);
    event ValueRemoved(uint256 indexed index, uint256 value);
    
    // Marker for removed elements
    uint256 private constant REMOVED_MARKER = type(uint256).max;
    
    // Add a new value to the array
    function addValue(uint256 _value) external returns (uint256 index) {
        require(_value != REMOVED_MARKER, "Invalid value");
        
        index = state.length;
        values[index] = _value; // Equivalent to values.push(_value)
        
        state.length++;
        state.elementCount++;
        totalSum += _value;
        lastAdded = _value;
        operationCount++;
        
        emit ValueAdded(index, _value);
    }
    
    // Get value at specific index
    function getValue(uint256 _index) external view returns (uint256) {
        require(_index < state.length, "Index out of bounds");
        uint256 value = values[_index];
        require(value != REMOVED_MARKER, "Element removed");
        return value;
    }
    
    // Update value at specific index
    function updateValue(uint256 _index, uint256 _newValue) external {
        require(_newValue != REMOVED_MARKER, "Invalid value");
        require(_index < state.length, "Index out of bounds");
        
        uint256 oldValue = values[_index];
        require(oldValue != REMOVED_MARKER, "Element removed");
        values[_index] = _newValue;
        
        // Update totalSum
        totalSum = totalSum - oldValue + _newValue;
        operationCount++;
        
        emit ValueUpdated(_index, oldValue, _newValue);
    }
    
    // Remove value at specific index (optimized - no shifting needed!)
    function removeValue(uint256 _index) external {
        require(_index < state.length, "Index out of bounds");
        
        uint256 removedValue = values[_index];
        require(removedValue != REMOVED_MARKER, "Element already removed");
        
        // Instead of expensive shifting, just mark as removed
        values[_index] = REMOVED_MARKER;
        
        totalSum -= removedValue;
        state.elementCount--;
        lastRemoved = removedValue;
        operationCount++;
        
        emit ValueRemoved(_index, removedValue);
    }
    
    // Get array length
    function getLength() external view returns (uint256) {
        return state.length;
    }
    
    // Get element count (replaces public elementCount)
    function elementCount() external view returns (uint256) {
        return state.elementCount;
    }
    
    // Check if a value exists in the array (requires iteration)
    function containsValue(uint256 _value) external view returns (bool) {
        if (_value == REMOVED_MARKER) return false;
        
        for (uint256 i = 0; i < state.length; i++) {
            if (values[i] == _value) {
                return true;
            }
        }
        return false;
    }
    
    // Get sum of range (can iterate)
    function getRangeSum(uint256 _start, uint256 _end) external view returns (uint256 sum) {
        require(_start <= _end && _end < state.length, "Invalid range");
        
        for (uint256 i = _start; i <= _end; i++) {
            uint256 value = values[i];
            if (value != REMOVED_MARKER) {
                sum += value;
            }
        }
    }
    
    // Find index of value (requires iteration)
    function indexOf(uint256 _value) external view returns (uint256) {
        if (_value == REMOVED_MARKER) revert("Invalid search value");
        
        for (uint256 i = 0; i < state.length; i++) {
            if (values[i] == _value) {
                return i;
            }
        }
        revert("Value not found");
    }
    
    // Batch add values
    function batchAdd(uint256[] calldata _values) external {
        for (uint256 i = 0; i < _values.length; i++) {
            require(_values[i] != REMOVED_MARKER, "Invalid value");
            values[state.length + i] = _values[i]; // Equivalent to values.push(_values[i])
            totalSum += _values[i];
        }
        
        state.length += uint128(_values.length);
        state.elementCount += uint128(_values.length);
        
        if (_values.length > 0) {
            lastAdded = _values[_values.length - 1];
            operationCount += _values.length;
        }
    }
    
    // Clear all values
    function clear() external {
        // Delete all values in mapping
        for (uint256 i = 0; i < state.length; i++) {
            delete values[i];
        }
        
        // Reset state (equivalent to delete values array)
        delete state;
        totalSum = 0;
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
        return (totalSum, state.elementCount, lastAdded, lastRemoved, operationCount, state.length);
    }
}