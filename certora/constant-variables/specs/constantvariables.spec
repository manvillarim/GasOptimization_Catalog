using A as a;
using Ao as ao;

methods {
    function a.maxSupply() external returns (uint256) envfree;
    function ao.maxSupply() external returns (uint256) envfree;
    function a.mintingFee() external returns (uint256) envfree;
    function ao.mintingFee() external returns (uint256) envfree;
    function a.isPaused() external returns (bool) envfree;
    function ao.isPaused() external returns (bool) envfree;
    function a.checkLimits(uint256) external returns (bool) envfree;
    function ao.checkLimits(uint256) external returns (bool) envfree;
    function a.calculateFees(uint256) external returns (uint256) envfree;
    function ao.calculateFees(uint256) external returns (uint256) envfree;
}

definition couplingInv() returns bool =
    a.maxSupply() == ao.maxSupply() &&
    a.mintingFee() == ao.mintingFee() &&
    a.isPaused() == ao.isPaused() &&
    (forall address u. a.balances[u] == ao.balances[u]);

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

rule gasOptimizedCorrectnessOfTransfer(method f, method g)
    filtered {
        f -> f.selector == sig:a.transfer(address, uint256).selector,
        g -> g.selector == sig:ao.transfer(address, uint256).selector
    } {
    gasOptimizationCorrectness(f, g);
}

rule gasOptimizedCorrectnessOfSetPaused(method f, method g)
    filtered {
        f -> f.selector == sig:a.setPaused(bool).selector,
        g -> g.selector == sig:ao.setPaused(bool).selector
    } {
    gasOptimizationCorrectness(f, g);
}

rule gasOptimizedCorrectnessOfCredit(method f, method g)
    filtered {
        f -> f.selector == sig:a.credit(address, uint256).selector,
        g -> g.selector == sig:ao.credit(address, uint256).selector
    } {
    gasOptimizationCorrectness(f, g);
}

rule returnsOfCheckLimits(uint256 amount) {
    require couplingInv();
    assert a.checkLimits(amount) == ao.checkLimits(amount);
}

rule returnsOfCalculateFees(uint256 amount) {
    require couplingInv();
    assert a.calculateFees(amount) == ao.calculateFees(amount);
}
