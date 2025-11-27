// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * Contract A - Using Memory Parameters
 * This contract demonstrates the use of memory for function parameters
 * which requires copying data from calldata to memory, consuming more gas
 */
contract A {
    // Simple state variables
    uint256 public totalSum;
    uint256 public totalCount;
    uint256 public lastAverage;
    uint256 public processedArrays;
    uint256 public maxValue;
    uint256 public minValue;
    
    // Events
    event ArrayProcessed(uint256 sum, uint256 average, uint256 count);
    event ValuesUpdated(uint256 max, uint256 min);
    event BatchProcessed(uint256 totalProcessed);
    
    
    // Process array of numbers - using memory
    function processArray(uint256[] memory numbers) external returns (uint256 sum, uint256 average) {
        require(numbers.length > 0, "Empty array");
        
        for (uint256 i = 0; i < numbers.length; i++) {
            sum += numbers[i];assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000000b,sum)}
            
            // Update max and min
            if (numbers[i] > maxValue) {
                maxValue = numbers[i];
            }
            if (numbers[i] < minValue) {
                minValue = numbers[i];
            }
        }
        
        average = sum / numbers.length;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000004,average)}
        
        // Update state
        totalSum += sum;
        totalCount += numbers.length;
        lastAverage = average;
        processedArrays++;
        
        emit ArrayProcessed(sum, average, numbers.length);
        
        return (sum, average);
    }
    
    // Calculate statistics from array - using memory
    function calculateStats(uint256[] memory data) external pure returns (
        uint256 sum,
        uint256 min,
        uint256 max,
        uint256 average
    ) {
        require(data.length > 0, "Empty array");
        
        sum = data[0];assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000005,sum)}
        min = data[0];assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000006,min)}
        max = data[0];assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000007,max)}
        
        for (uint256 i = 1; i < data.length; i++) {
            sum += data[i];assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000000c,sum)}
            if (data[i] < min) min = data[i];
            if (data[i] > max) max = data[i];
        }
        
        average = sum / data.length;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000008,average)}
        
        return (sum, min, max, average);
    }
        
    // Find specific values in array - using memory
    function findValues(uint256[] memory haystack, uint256[] memory needles) external pure returns (bool[] memory found) {
        found = new bool[](needles.length);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00020009,0)}
        
        for (uint256 i = 0; i < needles.length; i++) {
            for (uint256 j = 0; j < haystack.length; j++) {
                if (haystack[j] == needles[i]) {
                    found[i] = true;
                    break;
                }
            }
        }
        
        return found;
    }
    
    // Merge two sorted arrays - using memory
    function mergeSorted(uint256[] memory arr1, uint256[] memory arr2) external pure returns (uint256[] memory result) {
        result = new uint256[](arr1.length + arr2.length);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0002000a,0)}
        uint256 i = 0;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000001,i)}
        uint256 j = 0;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000002,j)}
        uint256 k = 0;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000003,k)}
        
        while (i < arr1.length && j < arr2.length) {
            if (arr1[i] <= arr2[j]) {
                result[k++] = arr1[i++];
            } else {
                result[k++] = arr2[j++];uint256 certora_local15 = result[k++];assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000000f,certora_local15)}
            }
        }
        
        while (i < arr1.length) {
            result[k++] = arr1[i++];uint256 certora_local13 = result[k++];assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000000d,certora_local13)}
        }
        
        while (j < arr2.length) {
            result[k++] = arr2[j++];uint256 certora_local14 = result[k++];assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000000e,certora_local14)}
        }
        
        return result;
    }
    
    
    // Get current statistics
    function getStats() external view returns (
        uint256 _totalSum,
        uint256 _totalCount,
        uint256 _lastAverage,
        uint256 _processedArrays,
        uint256 _maxValue,
        uint256 _minValue
    ) {
        return (totalSum, totalCount, lastAverage, processedArrays, maxValue, minValue);
    }
}