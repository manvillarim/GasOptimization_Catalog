// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Ao {
    // Storage variables that will be accessed repeatedly in loops
    uint256 public total;
    uint256 public accumulator;
    uint256 public counter;
    uint256 public sumOfSquares;
    uint256 public productTotal;
    uint256 public weightedSum;
    
    uint256[] public values;
    uint256[] public weights;
    mapping(address => uint256) public userBalances;
    address[] public users;
    
    // State variables for complex calculations
    uint256 public globalMultiplier = 2;
    uint256 public globalDivisor = 100;
    uint256 public bonusThreshold = 1000;
    
    event TotalUpdated(uint256 newTotal);
    event AccumulatorUpdated(uint256 newAccumulator);
    event CalculationComplete(string operation, uint256 result);
    
    constructor() {
        // Initialize with sample data
        for (uint256 i = 0; i < 10; i++) {
            values.push(10 + i * 5);
            weights.push(100 - i * 5);
        }
        
        // Initialize some user balances
        users.push(address(0x1));
        users.push(address(0x2));
        users.push(address(0x3));
        userBalances[address(0x1)] = 100;
        userBalances[address(0x2)] = 200;
        userBalances[address(0x3)] = 300;
    }
    
    // OPTIMIZED: Use local variable instead of repeated storage access
    function calculateTotal() external {
        uint256 length = values.length;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000001,length)}
        uint256 localTotal = 0;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000002,localTotal)} // Local variable instead of storage
        
        for (uint256 i = 0; i < length; i++) {
            localTotal += values[i];assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000001d,localTotal)} // Only memory operations
        }
        
        total = localTotal; // Single storage write at the end
        emit TotalUpdated(total);
    }
    
    // OPTIMIZED: Multiple storage variables cached locally
    function complexCalculation() external {
        uint256 length = values.length;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000003,length)}
        uint256 localAccumulator = 0;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000004,localAccumulator)}  // Local variable
        uint256 localCounter = 0;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000005,localCounter)}      // Local variable
        uint256 localSumOfSquares = sumOfSquares;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000006,localSumOfSquares)} // Load current value to local
        
        for (uint256 i = 0; i < length; i++) {
            localAccumulator += values[i];assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000001e,localAccumulator)}              // Memory operation
            localCounter += 1;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000001f,localCounter)}                           // Memory operation
            localSumOfSquares += values[i] * values[i];assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000020,localSumOfSquares)} // Memory operation
        }
        
        // Write back to storage once at the end
        accumulator = localAccumulator;
        counter = localCounter;
        sumOfSquares = localSumOfSquares;
        
        emit CalculationComplete("complex", accumulator);
    }
    
    // OPTIMIZED: Nested loops with local variable
    function nestedCalculation() external {
        uint256 outerLength = values.length;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000007,outerLength)}
        uint256 innerLength = weights.length;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000008,innerLength)}
        uint256 localTotal = 0;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000009,localTotal)} // Local variable
        
        for (uint256 i = 0; i < outerLength; i++) {
            for (uint256 j = 0; j < innerLength; j++) {
                localTotal += values[i] * weights[j] / 100;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000026,localTotal)} // Memory operations only
            }
        }
        
        total = localTotal; // Single storage write
        emit TotalUpdated(total);
    }
    
    // OPTIMIZED: Conditional accumulation with local variable
    function conditionalAccumulation(uint256 threshold) external {
        uint256 length = values.length;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000000a,length)}
        uint256 localAccumulator = 0;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000000b,localAccumulator)} // Local variable
        
        for (uint256 i = 0; i < length; i++) {
            if (values[i] > threshold) {
                localAccumulator += values[i]; // Memory operation
            }
        }
        
        accumulator = localAccumulator; // Single storage write
        emit AccumulatorUpdated(accumulator);
    }
    
    // OPTIMIZED: Batch mapping updates with local tracking
    function distributeRewards(uint256 rewardPerUser) external {
        uint256 length = users.length;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000000c,length)}
        uint256 localTotal = total;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000000d,localTotal)} // Load current total to local
        
        for (uint256 i = 0; i < length; i++) {
            address user = users[i];assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000001b,user)}
            // Still need to update mapping in loop (can't be optimized further)
            userBalances[user] += rewardPerUser;
        }
        
        localTotal += rewardPerUser * length;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000001a,localTotal)} // Calculate in memory
        total = localTotal; // Single storage write
        emit TotalUpdated(total);
    }
    
    // OPTIMIZED: Cache storage variables used multiple times
    function calculateWeightedSum() external {
        uint256 length = values.length;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000000e,length)}
        uint256 localWeightedSum = 0;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000000f,localWeightedSum)} // Local variable
        uint256 localMultiplier = globalMultiplier;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000010,localMultiplier)}   // Cache storage value
        uint256 localDivisor = globalDivisor;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000011,localDivisor)}         // Cache storage value
        uint256 localThreshold = bonusThreshold;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000012,localThreshold)}      // Cache storage value
        
        for (uint256 i = 0; i < length; i++) {
            // Use cached values instead of storage reads
            uint256 weighted = values[i] * localMultiplier / localDivisor;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000001c,weighted)}
            localWeightedSum += weighted;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000021,localWeightedSum)}
            
            // Bonus calculation with cached threshold
            if (localWeightedSum > localThreshold) {
                localWeightedSum += 10;
            }
        }
        
        weightedSum = localWeightedSum; // Single storage write
        emit CalculationComplete("weighted", weightedSum);
    }
    
    // OPTIMIZED: Product calculation with local variable
    function incrementalProduct() external {
        uint256 length = values.length;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000013,length)}
        uint256 localProduct = 1;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000014,localProduct)} // Local variable
        
        for (uint256 i = 0; i < length; i++) {
            localProduct *= (values[i] + 1);assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000022,localProduct)}         // Memory operation
            localProduct = localProduct % 1000000;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000023,localProduct)}   // Memory operation
        }
        
        productTotal = localProduct; // Single storage write
        emit CalculationComplete("product", productTotal);
    }
    
    // OPTIMIZED: Multiple storage operations with local caching
    function multiStorageOperation() external {
        uint256 length = values.length;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000015,length)}
        uint256 localTotal = total;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000016,localTotal)}           // Cache storage
        uint256 localAccumulator = accumulator;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000017,localAccumulator)} // Cache storage
        uint256 localCounter = counter;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000018,localCounter)}       // Cache storage
        uint256 localSumOfSquares = sumOfSquares;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000019,localSumOfSquares)} // Cache storage
        
        for (uint256 i = 0; i < length; i++) {
            localTotal += values[i];assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000024,localTotal)}              // Memory operation
            localAccumulator -= values[i] / 2;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000025,localAccumulator)}    // Memory operation
            localCounter++;                        // Memory operation
            
            // Complex operation with local variables
            if (localTotal > localAccumulator * 2) {
                localSumOfSquares += values[i] * values[i]; // Memory operation
            }
        }
        
        // Write all values back to storage at once
        total = localTotal;
        accumulator = localAccumulator;
        counter = localCounter;
        sumOfSquares = localSumOfSquares;
        
        emit CalculationComplete("multi", total);
    }
    
    // Helper functions (identical to contract A)
    function addValue(uint256 value) external {
        values.push(value);
    }
    
    function addWeight(uint256 weight) external {
        weights.push(weight);
    }
    
    function addUser(address user, uint256 balance) external {
        users.push(user);
        userBalances[user] = balance;
    }
    
    function getValuesLength() external view returns (uint256) {
        return values.length;
    }
    
    function getWeightsLength() external view returns (uint256) {
        return weights.length;
    }
    
    function getUsersLength() external view returns (uint256) {
        return users.length;
    }
    
    // Reset functions for testing
    function resetTotals() external {
        total = 0;
        accumulator = 0;
        counter = 0;
        sumOfSquares = 0;
        productTotal = 0;
        weightedSum = 0;
    }
}