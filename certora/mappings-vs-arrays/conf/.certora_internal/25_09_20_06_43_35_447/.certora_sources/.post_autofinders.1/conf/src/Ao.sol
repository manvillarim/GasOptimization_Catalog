// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * Contract Ao - Optimized with Array-like Semantics
 * This version maintains equivalence with contract A while optimizing storage
 */
contract Ao {
    // Mapping storage for values
    mapping(uint256 => uint256) public values;
    
    // Array to track active indices (maintains order)
    uint256[] public activeIndices;
    
    // Reverse mapping: value position -> activeIndices position
    mapping(uint256 => uint256) indexPosition;

    // Counter to guarantee unique storage keys, preventing collisions after removals.
    uint256 private nextAvailableIndex;
    
    // State tracking (same as A)
    uint256 public totalSum;
    uint256 public elementCount;
    uint256 public lastAdded;
    uint256 public lastRemoved;
    uint256 public operationCount;
    
    // Events (same as A)
    event ValueAdded(uint256 indexed index, uint256 value);
    event ValueUpdated(uint256 indexed index, uint256 oldValue, uint256 newValue);
    event ValueRemoved(uint256 indexed index, uint256 value);
    
    // Add a new value (returns sequential index like A)
    function addValue(uint256 _value) external returns (uint256 index) {
        uint256 realIndex = nextAvailableIndex;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000001,realIndex)}
        index = activeIndices.length;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000009,index)}
        
        values[realIndex] = _value;
        activeIndices.push(realIndex);
        indexPosition[realIndex] = index;
        
        totalSum += _value;
        elementCount++;
        lastAdded = _value;
        operationCount++;
        
        nextAvailableIndex++;
        
        emit ValueAdded(index, _value);
    }
    
    // Get value at specific index (array-like behavior)
    function getValue(uint256 _index) external view returns (uint256) {
        require(_index < activeIndices.length, "Index out of bounds");
        uint256 realIndex = activeIndices[_index];assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000002,realIndex)}
        return values[realIndex];
    }
    
    // Update value at specific index
    function updateValue(uint256 _index, uint256 _newValue) external {
        require(_index < activeIndices.length, "Index out of bounds");
        uint256 realIndex = activeIndices[_index];assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000003,realIndex)}
        
        uint256 oldValue = values[realIndex];assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000004,oldValue)}
        values[realIndex] = _newValue;
        
        totalSum = totalSum - oldValue + _newValue;
        operationCount++;
        
        emit ValueUpdated(_index, oldValue, _newValue);
    }
    
    // Remove value maintaining array-like semantics
    function removeValue(uint256 _index) external {
        require(_index < activeIndices.length, "Index out of bounds");
        
        uint256 realIndex = activeIndices[_index];assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000005,realIndex)}
        uint256 removedValue = values[realIndex];assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000006,removedValue)}
        
        uint256 lastPos = activeIndices.length - 1;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000007,lastPos)}
        uint256 lastRealIndex = activeIndices[lastPos];assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000008,lastRealIndex)}
        
        if (_index != lastPos) {
            activeIndices[_index] = lastRealIndex;
            indexPosition[lastRealIndex] = _index;
        }
        
        delete values[realIndex];
        delete indexPosition[realIndex];
        activeIndices.pop();
        
        totalSum -= removedValue;
        elementCount--;
        lastRemoved = removedValue;
        operationCount++;
        
        emit ValueRemoved(_index, removedValue);
    }
    
    // Get length (compatible with A)
    function getLength() external view returns (uint256) {
        return activeIndices.length;
    }
    
    // Check if value exists (iteration required for compatibility)
    function containsValue(uint256 _value) external view returns (bool) {
        for (uint256 i = 0; i < activeIndices.length; i++) {
            if (values[activeIndices[i]] == _value) {
                return true;
            }
        }
        return false;
    }
    
    // Get sum of range
    function getRangeSum(uint256 _start, uint256 _end) external view returns (uint256 sum) {
        require(_start <= _end && _end < activeIndices.length, "Invalid range");
        
        for (uint256 i = _start; i <= _end; i++) {
            sum += values[activeIndices[i]];assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000000c,sum)}
        }
    }
    
    // Find index of value
    function indexOf(uint256 _value) external view returns (uint256) {
        for (uint256 i = 0; i < activeIndices.length; i++) {
            if (values[activeIndices[i]] == _value) {
                return i;
            }
        }
        revert("Value not found");
    }
    
    // Batch add values
    function batchAdd(uint256[] calldata _values) external {
        for (uint256 i = 0; i < _values.length; i++) {
            uint256 realIndex = nextAvailableIndex;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000000a,realIndex)}
            uint256 logicalIndex = activeIndices.length;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000000b,logicalIndex)}

            values[realIndex] = _values[i];
            activeIndices.push(realIndex);
            indexPosition[realIndex] = logicalIndex;
            
            totalSum += _values[i];
            elementCount++;
            
            nextAvailableIndex++;
        }
        
        if (_values.length > 0) {
            lastAdded = _values[_values.length - 1];
            operationCount += _values.length;
        }
    }
    
    // Clear all values
    function clear() external {
        for (uint256 i = 0; i < activeIndices.length; i++) {
            delete values[activeIndices[i]];
            delete indexPosition[activeIndices[i]];
        }
        delete activeIndices;
        
        totalSum = 0;
        elementCount = 0;
        nextAvailableIndex = 0; // Reset the counter
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
        return (totalSum, elementCount, lastAdded, lastRemoved, operationCount, activeIndices.length);
    }
    
    // Helper to check internal consistency (for testing)
    function exists(uint256 _index) external view returns (bool) {
        if (_index >= activeIndices.length) return false;
        return activeIndices[_index] < type(uint256).max;
    }
    
    // Get the actual storage index for a logical index
    function getStorageIndex(uint256 _logicalIndex) external view returns (uint256) {
        require(_logicalIndex < activeIndices.length, "Index out of bounds");
        return activeIndices[_logicalIndex];
    }
    function getNextAvailableIndex() external view returns (uint256) {
    return nextAvailableIndex;
}

}