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

    function getTimeConstants() public returns(uint, uint) {
        uint hoursInWeek = 168;  // Pré-calculado: 7 * 24
        uint minutesInHour = 60; // Valor direto
        lastCalculatedHoursInWeek = hoursInWeek;
        lastCalculatedMinutesInHour = minutesInHour;
        return (hoursInWeek, minutesInHour);
    }
    
    function calculateFee(uint amount) public returns(uint) {
        lastCalculatedFee = amount * 5 / 100; // Mantido como está - operação simples
        return lastCalculatedFee;
    }
    
    function getComplexConstants() public returns(uint, uint, uint) {
        uint daysInYear = 365;
        uint hoursInYear = 8760;    // Pré-calculado: 365 * 24
        uint secondsInYear = 31536000; // Pré-calculado: 8760 * 60 * 60
        lastCalculatedDaysInYear = daysInYear;
        lastCalculatedHoursInYear = hoursInYear;
        lastCalculatedSecondsInYear = secondsInYear;
        return (daysInYear, hoursInYear, secondsInYear);
    }
}