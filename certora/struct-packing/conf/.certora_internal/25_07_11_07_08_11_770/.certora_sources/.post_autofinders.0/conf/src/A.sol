// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract A {
    uint public constant SECONDS_IN_DAY = 24 * 60 * 60; // Calculado em tempo de execução
    uint public constant WEI_IN_ETHER = 10 ** 18;       // Calculado em tempo de execução
    
    // Variáveis adicionais para garantir que o CVL tenha pontos de estado para comparar
    uint public lastCalculatedHoursInWeek;
    uint public lastCalculatedMinutesInHour;
    uint public lastCalculatedFee;
    uint public lastCalculatedDaysInYear;
    uint public lastCalculatedHoursInYear;
    uint public lastCalculatedSecondsInYear;

    function getTimeConstants() public returns(uint, uint) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00000000, 1037618708480) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00000001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00000004, 0) }
        uint hoursInWeek = 7 * 24;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000001,hoursInWeek)}           // Cálculo em tempo de execução
        uint minutesInHour = 60;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000002,minutesInHour)}             // Poderia ser otimizado
        lastCalculatedHoursInWeek = hoursInWeek;
        lastCalculatedMinutesInHour = minutesInHour;
        return (hoursInWeek, minutesInHour);
    }
    
    function calculateFee(uint amount) public returns(uint) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00020000, 1037618708482) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00020001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00020005, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00026000, amount) }
        lastCalculatedFee = amount * 5 / 100; // Divisão em tempo de execução
        return lastCalculatedFee;
    }
    
    function getComplexConstants() public returns(uint, uint, uint) {assembly ("memory-safe") { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00010000, 1037618708481) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00010001, 0) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00010004, 0) }
        uint daysInYear = 365;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000003,daysInYear)}
        uint hoursInYear = daysInYear * 24;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000004,hoursInYear)}  // Cálculo em tempo de execução
        uint secondsInYear = hoursInYear * 60 * 60;assembly ("memory-safe"){mstore(0xffffff6e4604afefe123321beef1b02fffffffffffffffffffffffff00000005,secondsInYear)} // Cálculo em tempo de execução
        lastCalculatedDaysInYear = daysInYear;
        lastCalculatedHoursInYear = hoursInYear;
        lastCalculatedSecondsInYear = secondsInYear;
        return (daysInYear, hoursInYear, secondsInYear);
    }
}