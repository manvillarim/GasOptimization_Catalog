using A as a;
using Ao as ao;

methods {
    function a.validateUser(address) external returns (bool);
    function ao.validateUser(address) external returns (bool);
    function a.setBalance(uint) external;
    function ao.setBalance(uint) external;
    function a.lastValidationResult() external returns (bool) envfree;
    function ao.lastValidationResult() external returns (bool) envfree;
    function a.balance() external returns (uint) envfree;
    function ao.balance() external returns (uint) envfree;
}

// Both persistent variables are `public`, hence observable through their
// compiler-generated getters, and both appear here. lastValidationResult also
// materialises the value returned by validateUser, so comparing it discharges
// return equivalence within the uniform rule template.
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

rule gasOptimizedCorrectnessOfSetBalance(method f, method g)
    filtered {
        f -> f.selector == sig:a.setBalance(uint).selector,
        g -> g.selector == sig:ao.setBalance(uint).selector
    } {
    gasOptimizationCorrectness(f, g);
}