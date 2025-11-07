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

    function getTimeConstants() public returns(uint, uint) {
        uint hoursInWeek = 7 * 24;           // Cálculo em tempo de execução
        uint minutesInHour = 60;             // Poderia ser otimizado
        lastCalculatedHoursInWeek = hoursInWeek;
        lastCalculatedMinutesInHour = minutesInHour;
        return (hoursInWeek, minutesInHour);
    }
    
    function calculateFee(uint amount) public returns(uint) {
        lastCalculatedFee = amount * 5 / 100; // Divisão em tempo de execução
        return lastCalculatedFee;
    }
    
    function getComplexConstants() public returns(uint, uint, uint) {
        uint daysInYear = 365;
        uint hoursInYear = daysInYear * 24;  // Cálculo em tempo de execução
        uint secondsInYear = hoursInYear * 60 * 60; // Cálculo em tempo de execução
        lastCalculatedDaysInYear = daysInYear;
        lastCalculatedHoursInYear = hoursInYear;
        lastCalculatedSecondsInYear = secondsInYear;
        return (daysInYear, hoursInYear, secondsInYear);
    }
}