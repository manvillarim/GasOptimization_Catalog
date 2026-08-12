using A as a;
using Ao as ao;

methods {
    function a.owner() external returns (address) envfree;
    function ao.owner() external returns (address) envfree;
    function a.creationTime() external returns (uint256) envfree;
    function ao.creationTime() external returns (uint256) envfree;
    function a.maxSupply() external returns (uint256) envfree;
    function ao.maxSupply() external returns (uint256) envfree;
}

definition couplingInv() returns bool =
    a.owner() == ao.owner() &&
    a.creationTime() == ao.creationTime() &&
    a.maxSupply() == ao.maxSupply() &&
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

rule gasOptimizedCorrectnessOfMint(method f, method g)
    filtered {
        f -> f.selector == sig:a.mint(address, uint256).selector,
        g -> g.selector == sig:ao.mint(address, uint256).selector
    } {
    gasOptimizationCorrectness(f, g);
}
