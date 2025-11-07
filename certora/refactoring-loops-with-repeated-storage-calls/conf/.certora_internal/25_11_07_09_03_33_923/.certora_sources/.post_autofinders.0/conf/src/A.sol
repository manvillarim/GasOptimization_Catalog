// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract A {
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
    
    // Simple loop with repeated storage write to 'total'
    function calculateTotal() external {
        uint256 length = values.length;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000001,length)}
        total = 0; // Storage write
        
        for (uint256 i = 0; i < length; i++) {
            total += values[i]; // Storage read + write in each iteration
        }
        
        emit TotalUpdated(total);
    }
    
    // Loop with multiple storage variable updates
    function complexCalculation() external {
        uint256 length = values.length;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000002,length)}
        accumulator = 0; // Storage write
        counter = 0;     // Storage write
        
        for (uint256 i = 0; i < length; i++) {
            accumulator += values[i];           // Storage read + write
            counter += 1;                        // Storage read + write
            sumOfSquares += values[i] * values[i]; // Storage read + write
        }
        
        emit CalculationComplete("complex", accumulator);
    }
    
    // Nested loops with storage access
    function nestedCalculation() external {
        uint256 outerLength = values.length;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000003,outerLength)}
        uint256 innerLength = weights.length;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000004,innerLength)}
        total = 0; // Storage write
        
        for (uint256 i = 0; i < outerLength; i++) {
            for (uint256 j = 0; j < innerLength; j++) {
                total += values[i] * weights[j] / 100; // Storage read + write in nested loop
            }
        }
        
        emit TotalUpdated(total);
    }
    
    // Loop with conditional storage updates
    function conditionalAccumulation(uint256 threshold) external {
        uint256 length = values.length;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000005,length)}
        accumulator = 0; // Storage write
        
        for (uint256 i = 0; i < length; i++) {
            if (values[i] > threshold) {
                accumulator += values[i]; // Storage read + write (conditional)
            }
        }
        
        emit AccumulatorUpdated(accumulator);
    }
    
    // Loop with storage mapping updates
    function distributeRewards(uint256 rewardPerUser) external {
        uint256 length = users.length;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000006,length)}
        
        for (uint256 i = 0; i < length; i++) {
            address user = users[i];assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000000a,user)}
            userBalances[user] += rewardPerUser; // Storage mapping read + write
        }
        
        total += rewardPerUser * length; // Storage read + write
        emit TotalUpdated(total);
    }
    
    // Loop with multiple storage reads of the same variable
    function calculateWeightedSum() external {
        uint256 length = values.length;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000007,length)}
        weightedSum = 0; // Storage write
        
        for (uint256 i = 0; i < length; i++) {
            // Multiple reads of globalMultiplier and globalDivisor in each iteration
            uint256 weighted = values[i] * globalMultiplier / globalDivisor;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff0000000b,weighted)}
            weightedSum += weighted; // Storage read + write
            
            // Bonus calculation with another storage read
            if (weightedSum > bonusThreshold) { // Storage read
                weightedSum += 10; // Storage read + write
            }
        }
        
        emit CalculationComplete("weighted", weightedSum);
    }
    
    // Loop that modifies and uses storage variable
    function incrementalProduct() external {
        uint256 length = values.length;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000008,length)}
        productTotal = 1; // Storage write
        
        for (uint256 i = 0; i < length; i++) {
            productTotal *= (values[i] + 1); // Storage read + write
            productTotal = productTotal % 1000000; // Storage read + write (prevent overflow)
        }
        
        emit CalculationComplete("product", productTotal);
    }
    
    // Complex loop with multiple storage operations
    function multiStorageOperation() external {
        uint256 length = values.length;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000009,length)}
        
        for (uint256 i = 0; i < length; i++) {
            total += values[i];              // Storage read + write
            accumulator -= values[i] / 2;    // Storage read + write
            counter++;                        // Storage read + write
            
            // Complex operation with multiple storage reads
            if (total > accumulator * 2) {   // Storage reads
                sumOfSquares += values[i] * values[i]; // Storage read + write
            }
        }
        
        emit CalculationComplete("multi", total);
    }
    
    // Helper functions
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