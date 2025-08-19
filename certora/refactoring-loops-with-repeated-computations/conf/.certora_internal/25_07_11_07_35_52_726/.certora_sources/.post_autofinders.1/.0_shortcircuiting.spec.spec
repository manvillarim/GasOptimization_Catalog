using A as a;
using Ao as ao;

methods {
    function a.validateUser(address) external returns (bool);
    function ao.validateUser(address) external returns (bool);
    function a.expensiveCheckExecuted() external returns (bool) envfree;
    function ao.expensiveCheckExecuted() external returns (bool) envfree;
    function a.expensiveCheckBalance() external returns (uint) envfree;
    function ao.expensiveCheckBalance() external returns (uint) envfree;
    function a.lastValidationResult() external returns (bool) envfree;
    function ao.lastValidationResult() external returns (bool) envfree;
    function a.balances(address) external returns (uint) envfree;
    function ao.balances(address) external returns (uint) envfree;
    function a.setBalance(address, uint) external;
    function ao.setBalance(address, uint) external;
}

ghost mapping(address => uint) ghostBalancesA;
ghost mapping(address => uint) ghostBalancesAo;

hook Sstore a.balances[KEY address addr] uint newValue {
    ghostBalancesA[addr] = newValue;
}

hook Sstore ao.balances[KEY address addr] uint newValue {
    ghostBalancesAo[addr] = newValue;
}

definition couplingInv() returns bool =
    (forall address addr. (ghostBalancesA[addr] == ghostBalancesAo[addr])) &&
    a.lastValidationResult() == ao.lastValidationResult();

function gasOptimizationCorrectness(method f, method g) {
    env eA;
    env eAo;
    calldataarg args;
    require eA == eAo && couplingInv();
    a.f(eA, args);
    ao.g(eAo, args);
    assert couplingInv();
}

rule gasOptimizedCorrectnessOfValidateUserForZeroAddress(method f, method g) 
    filtered {
        f -> f.selector == sig:a.validateUser(address).selector,
        g -> g.selector == sig:ao.validateUser(address).selector
    } {
    gasOptimizationCorrectness(f, g);
}

rule gasOptimizedCorrectnessOfValidateUserForValidAddressLowBalance(method f, method g) 
    filtered {
        f -> f.selector == sig:a.validateUser(address).selector,
        g -> g.selector == sig:ao.validateUser(address).selector
    } {
    gasOptimizationCorrectness(f, g);
}

rule gasOptimizedCorrectnessOfValidateUserForValidAddressHighBalance(method f, method g) 
    filtered {
        f -> f.selector == sig:a.validateUser(address).selector,
        g -> g.selector == sig:ao.validateUser(address).selector
    } {
    gasOptimizationCorrectness(f, g);
}