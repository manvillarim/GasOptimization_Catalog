using A as a;
using Ao as ao;

methods {
    function a.owner() external returns (address) envfree;
    function ao.owner() external returns (address) envfree;
    function a.getBalance(address) external returns (uint256) envfree;
    function ao.getBalance(address) external returns (uint256) envfree;
    function a.getTotalTokens() external returns (uint256) envfree;
    function ao.getTotalSupply() external returns (uint256) envfree;
}

definition couplingInv() returns bool =
    a.owner() == ao.owner() &&
    a.getTotalTokens() == ao.getTotalSupply() &&
    a.maxSupply == ao.maxSupply &&
    (forall address u. a.balances[u] == ao.balances[u]) && 
    (forall address u. a.isAuthorized[u] == ao.isAuthorized[u]);

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

rule gasOptimizedCorrectnessOfSetOwner(method f, method g)
filtered {
    f -> f.selector == sig:a.setOwner(address).selector,
    g -> g.selector == sig:ao.setOwner(address).selector
} {
    gasOptimizationCorrectness(f, g);
}

rule gasOptimizedCorrectnessOfMintTokens(method f, method g)
filtered {
    f -> f.selector == sig:a.mintTokens(address,uint256).selector,
    g -> g.selector == sig:ao.mintTokens(address,uint256).selector
} {
    gasOptimizationCorrectness(f, g);
}

rule gasOptimizedCorrectnessOfBurnTokens(method f, method g)
filtered {
    f -> f.selector == sig:a.burnTokens(address,uint256).selector,
    g -> g.selector == sig:ao.burnTokens(address,uint256).selector
} {
    gasOptimizationCorrectness(f, g);
}

rule gasOptimizedCorrectnessOfTransferTokens(method f, method g)
filtered {
    f -> f.selector == sig:a.transferTokens(address,address,uint256).selector,
    g -> g.selector == sig:ao.transferTokens(address,address,uint256).selector
} {
    gasOptimizationCorrectness(f, g);
}

rule gasOptimizedCorrectnessOfAuthorizeUser(method f, method g)
filtered {
    f -> f.selector == sig:a.authorizeUser(address).selector,
    g -> g.selector == sig:ao.authorizeUser(address).selector
} {
    gasOptimizationCorrectness(f, g);
}

rule gasOptimizedCorrectnessOfGetBalance(method f, method g)
filtered {
    f -> f.selector == sig:a.getBalance(address).selector,
    g -> g.selector == sig:ao.getBalance(address).selector
} {
    gasOptimizationCorrectness(f, g);
}