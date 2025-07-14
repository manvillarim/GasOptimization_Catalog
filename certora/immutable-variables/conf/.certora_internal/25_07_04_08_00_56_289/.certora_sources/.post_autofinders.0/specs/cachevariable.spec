using A as a;
using Ao as ao;

methods {

    function a.processNumbers() external;
    function ao.processNumbers() external;
    function a.calculateAverage() external;
    function ao.calculateAverage() external;

    function a.getTotal() external returns (uint) envfree;
    function ao.getTotal() external returns (uint) envfree;
    function a.getCount() external returns (uint) envfree;
    function ao.getCount() external returns (uint) envfree;

    function a.getNumbersLength() external returns (uint) envfree;
    function ao.getNumbersLength() external returns (uint) envfree;
}


definition couplingInv() returns bool =
    a.total == ao.total &&       
    a.count == ao.count &&       
    a.numbers.length == ao.numbers.length && 
    (
        a.numbers.length == 0 || 
        (forall uint256 i. (i < a.numbers.length => a.numbers[i] == ao.numbers[i])) 
    );


function gasOptimizationCorrectness(method f, method g) { 
    env eA;
    env eAo;
    calldataarg args;

    require eA == eAo && couplingInv();

    a.f(eA, args);
    ao.g(eAo, args);

    assert couplingInv();
}


rule gasOptimizedCorrectnessOfProcessNumbers(method f, method g) 
    filtered {
        f -> f.selector == sig:a.processNumbers().selector,
        g -> g.selector == sig:ao.processNumbers().selector
    } {
    gasOptimizationCorrectness(f, g);
}

rule gasOptimizedCorrectnessOfCalculateAverage(method f, method g) 
    filtered {
        f -> f.selector == sig:a.calculateAverage().selector,
        g -> g.selector == sig:ao.calculateAverage().selector
    } {
    gasOptimizationCorrectness(f, g);
}