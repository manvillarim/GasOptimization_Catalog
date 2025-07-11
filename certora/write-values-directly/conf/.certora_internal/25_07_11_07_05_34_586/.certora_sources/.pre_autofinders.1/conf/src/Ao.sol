// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Ao {
    uint public constant SECONDS_IN_DAY = 86400;  // Pre-computed: 24 * 60 * 60
    uint public constant WEI_IN_ETHER = 1000000000000000000; // Pre-computed: 10^18
    
    function getTimeConstants() public pure returns(uint, uint) {
        uint hoursInWeek = 168;  // Pre-computed: 7 * 24
        uint minutesInHour = 60; // Direct value
        return (hoursInWeek, minutesInHour);
    }
    
    function calculateFee(uint amount) public pure returns(uint) {
        return amount * 5 / 100; // Keep as is - simple operation
    }
    
    function getComplexConstants() public pure returns(uint, uint, uint) {
        uint daysInYear = 365;
        uint hoursInYear = 8760;    // Pre-computed: 365 * 24
        uint secondsInYear = 31536000; // Pre-computed: 8760 * 60 * 60
        return (daysInYear, hoursInYear, secondsInYear);
    }
}