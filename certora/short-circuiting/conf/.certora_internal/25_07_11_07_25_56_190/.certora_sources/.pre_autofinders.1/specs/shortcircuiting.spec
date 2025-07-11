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


definition couplingInv() returns bool =
    (forall address addr. (a.balances(addr) == ao.balances(addr))) &&
    a.lastValidationResult == ao.lastValidationResult;


function gasOptimizationCorrectness(method f, method g, address user, uint balanceValue) { 
    env eA;
    env eAo;

    a.setBalance(eA, user, balanceValue);
    ao.setBalance(eAo, user, balanceValue);

    require eA == eAo && couplingInv();

    a.f(eA, user);
    ao.g(eAo, user);

    assert couplingInv();
}


rule gasOptimizedCorrectnessOfValidateUserForZeroAddress(method f, method g) 
    filtered {
        f -> f.selector == sig:a.validateUser(address).selector,
        g -> g.selector == sig:ao.validateUser(address).selector
    } {
    address zeroAddr = address(0);
    uint anyBalance; 

    gasOptimizationCorrectness(f, g, zeroAddr, anyBalance);

    assert a.expensiveCheckExecuted() == true;
    assert ao.expensiveCheckExecuted() == false;
    assert a.expensiveCheckBalance() == a.balances(zeroAddr);
}

rule gasOptimizedCorrectnessOfValidateUserForValidAddressLowBalance(method f, method g) 
    filtered {
        f -> f.selector == sig:a.validateUser(address).selector,
        g -> g.selector == sig:ao.validateUser(address).selector
    } {
    address user;
    uint lowBalance;

    require lowBalance < 1000 && user != address(0);

    gasOptimizationCorrectness(f, g, user, lowBalance);

    assert a.expensiveCheckExecuted() == true;
    assert ao.expensiveCheckExecuted() == true;
    assert a.expensiveCheckBalance() == ao.expensiveCheckBalance();
    assert a.expensiveCheckBalance() == a.balances(user);
    assert a.lastValidationResult() == (user != address(0) && a.balances(user) > 1000);
}

rule gasOptimizedCorrectnessOfValidateUserForValidAddressHighBalance(method f, method g) 
    filtered {
        f -> f.selector == sig:a.validateUser(address).selector,
        g -> g.selector == sig:ao.validateUser(address).selector
    } {
    address user;
    uint highBalance;

    require highBalance > 1000 && user != address(0);

    gasOptimizationCorrectness(f, g, user, highBalance);

    assert a.expensiveCheckExecuted() == true;
    assert ao.expensiveCheckExecuted() == true;
    assert a.expensiveCheckBalance() == ao.expensiveCheckBalance();
    assert a.expensiveCheckBalance() == a.balances(user);
    assert a.lastValidationResult() == (user != address(0) && a.balances(user) > 1000);
}