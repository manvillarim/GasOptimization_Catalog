using A as a;
using Ao as ao;

methods {
    function a.validateUser(address) external returns (bool);
    function ao.validateUser(address) external returns (bool);
    function a.expensiveCheckExecuted() external returns (bool) envfree;
    function ao.expensiveCheckExecuted() external returns (bool) envfree;
    function a.lastValidationResult() external returns (bool) envfree;
    function ao.lastValidationResult() external returns (bool) envfree;
    function a.balance() external returns (uint) envfree;
    function ao.balance() external returns (uint) envfree;
}

definition couplingInv() returns bool =
    a.balance() == ao.balance() &&
    a.lastValidationResult() == ao.lastValidationResult();

function gasOptimizationCorrectness(method f, method g) {
    env eA;
    env eAo;
    calldataarg args;
    
    require eA == eAo && couplingInv();

    a.f@withrevert(eA, args);
    bool a_reverted = lastReverted;

    ao.g@withrevert(eAo, args);
    bool ao_reverted = lastReverted;

    assert a_reverted == ao_reverted;
    assert couplingInv();
}

rule gasOptimizedCorrectnessOfValidateUser(method f, method g) 
    filtered {
        f -> f.selector == sig:a.validateUser(address).selector,
        g -> g.selector == sig:ao.validateUser(address).selector
    } {
    gasOptimizationCorrectness(f, g);
}