// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Ao {
    uint public constant SECONDS_IN_DAY = 86400;  // Pré-calculado: 24 * 60 * 60
    uint public constant WEI_IN_ETHER = 1000000000000000000; // Pré-calculado: 10^18
    
    // Variáveis adicionais para garantir que o CVL tenha pontos de estado para comparar
    uint public lastCalculatedHoursInWeek;
    uint public lastCalculatedMinutesInHour;
    uint public lastCalculatedFee;
    uint public lastCalculatedDaysInYear;
    uint public lastCalculatedHoursInYear;
    uint public lastCalculatedSecondsInYear;

    function getTimeConstants() public returns(uint, uint) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00030000, 1037618708483) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00030001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00030004, 0) }
        uint hoursInWeek = 168;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000001,hoursInWeek)}  // Pré-calculado: 7 * 24
        uint minutesInHour = 60;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000002,minutesInHour)} // Valor direto
        lastCalculatedHoursInWeek = hoursInWeek;
        lastCalculatedMinutesInHour = minutesInHour;
        return (hoursInWeek, minutesInHour);
    }
    
    function calculateFee(uint amount) public returns(uint) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00050000, 1037618708485) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00050001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00050005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00056000, amount) }
        lastCalculatedFee = amount * 5 / 100; // Mantido como está - operação simples
        return lastCalculatedFee;
    }
    
    function getComplexConstants() public returns(uint, uint, uint) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00040000, 1037618708484) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00040001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00040004, 0) }
        uint daysInYear = 365;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000003,daysInYear)}
        uint hoursInYear = 8760;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000004,hoursInYear)}    // Pré-calculado: 365 * 24
        uint secondsInYear = 31536000;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000005,secondsInYear)} // Pré-calculado: 8760 * 60 * 60
        lastCalculatedDaysInYear = daysInYear;
        lastCalculatedHoursInYear = hoursInYear;
        lastCalculatedSecondsInYear = secondsInYear;
        return (daysInYear, hoursInYear, secondsInYear);
    }
}