using A as a;
using Ao as ao;

methods {

    function a.getTimeConstants() external returns (uint, uint);
    function ao.getTimeConstants() external returns (uint, uint);
    function a.calculateFee(uint) external returns (uint);
    function ao.calculateFee(uint) external returns (uint);
    function a.getComplexConstants() external returns (uint, uint, uint);
    function ao.getComplexConstants() external returns (uint, uint, uint);

    function a.SECONDS_IN_DAY() external returns (uint) envfree;
    function ao.SECONDS_IN_DAY() external returns (uint) envfree;
    function a.WEI_IN_ETHER() external returns (uint) envfree;
    function ao.WEI_IN_ETHER() external returns (uint) envfree;
    
    function a.lastCalculatedHoursInWeek() external returns (uint) envfree;
    function ao.lastCalculatedHoursInWeek() external returns (uint) envfree;
    function a.lastCalculatedMinutesInHour() external returns (uint) envfree;
    function ao.lastCalculatedMinutesInHour() external returns (uint) envfree;
    function a.lastCalculatedFee() external returns (uint) envfree;
    function ao.lastCalculatedFee() external returns (uint) envfree;
    function a.lastCalculatedDaysInYear() external returns (uint) envfree;
    function ao.lastCalculatedDaysInYear() external returns (uint) envfree;
    function a.lastCalculatedHoursInYear() external returns (uint) envfree;
    function ao.lastCalculatedHoursInYear() external returns (uint) envfree;
    function a.lastCalculatedSecondsInYear() external returns (uint) envfree;
    function ao.lastCalculatedSecondsInYear() external returns (uint) envfree;
}

definition couplingInv() returns bool =

    a.SECONDS_IN_DAY() == ao.SECONDS_IN_DAY() &&
    a.WEI_IN_ETHER() == ao.WEI_IN_ETHER() &&
    a.lastCalculatedHoursInWeek == ao.lastCalculatedHoursInWeek &&
    a.lastCalculatedMinutesInHour == ao.lastCalculatedMinutesInHour &&
    a.lastCalculatedFee == ao.lastCalculatedFee &&
    a.lastCalculatedDaysInYear == ao.lastCalculatedDaysInYear &&
    a.lastCalculatedHoursInYear == ao.lastCalculatedHoursInYear &&
    a.lastCalculatedSecondsInYear == ao.lastCalculatedSecondsInYear;

function gasOptimizationCorrectness(method f, method g) {
    env eA;
    env eAo;
    calldataarg args;

   
    require eA == eAo && couplingInv();

    a.f(eA, args);
    ao.g(eAo, args);

    assert couplingInv();
}


rule gasOptimizedCorrectnessOfGetTimeConstants(method f, method g)
    filtered {
        f -> f.selector == sig:a.getTimeConstants().selector,
        g -> g.selector == sig:ao.getTimeConstants().selector
    } {
    gasOptimizationCorrectness(f, g);
}

rule gasOptimizedCorrectnessOfCalculateFee(method f, method g)
    filtered {
        f -> f.selector == sig:a.calculateFee(uint).selector,
        g -> g.selector == sig:ao.calculateFee(uint).selector
    } {
    gasOptimizationCorrectness(f, g);
}

rule gasOptimizedCorrectnessOfGetComplexConstants(method f, method g)
    filtered {
        f -> f.selector == sig:a.getComplexConstants().selector,
        g -> g.selector == sig:ao.getComplexConstants().selector
    } {
    gasOptimizationCorrectness(f, g);
}