// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract A {
    uint public constant SECONDS_IN_DAY = 24 * 60 * 60; // Calculated at runtime
    uint public constant WEI_IN_ETHER = 10 ** 18;       // Calculated at runtime
    
    function getTimeConstants() public pure returns(uint, uint) {
        uint hoursInWeek = 7 * 24;           // Runtime calculation
        uint minutesInHour = 60;             // Could be optimized
        return (hoursInWeek, minutesInHour);
    }
    
    function calculateFee(uint amount) public pure returns(uint) {
        return amount * 5 / 100; // Runtime division
    }
    
    function getComplexConstants() public pure returns(uint, uint, uint) {
        uint daysInYear = 365;
        uint hoursInYear = daysInYear * 24;  // Runtime calculation
        uint secondsInYear = hoursInYear * 60 * 60; // Runtime calculation
        return (daysInYear, hoursInYear, secondsInYear);
    }
}
