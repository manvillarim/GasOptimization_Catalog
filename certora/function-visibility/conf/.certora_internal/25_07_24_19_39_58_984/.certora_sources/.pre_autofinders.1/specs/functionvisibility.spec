using A as a;
using Ao as ao;

methods {
    function a.owner() external returns (address) envfree;
    function ao.owner() external returns (address) envfree;
    function a.getBalance(address) external returns (uint256) envfree;
    function ao.getBalance(address) external returns (uint256) envfree;
    function a.getTotalTokens() external returns (uint256) envfree;
    function ao.getTotalSupply() external returns (uint256) envfree;
    function a.getMaxSupply() external returns (uint256) envfree;
    function a.isUserAuthorized(address) external returns (bool) envfree;
}

definition couplingInv() returns bool =
    a.owner() == ao.owner() &&
    a.getTotalTokens() == ao.getTotalSupply() &&
    a.getMaxSupply() == 1000000;

function gasOptimizationCorrectness(method f, method g) {
    env eA;
    env eAo;
    calldataarg args;
    
    require eA.msg.sender == eAo.msg.sender;
    require eA.msg.value == eAo.msg.value;
    require eA.block.timestamp == eAo.block.timestamp;
    
    address addr1; address addr2; address addr3;
    require a.getBalance(addr1) == ao.getBalance(addr1);
    require a.getBalance(addr2) == ao.getBalance(addr2);
    require a.getBalance(addr3) == ao.getBalance(addr3);
    require a.getBalance(eA.msg.sender) == ao.getBalance(eA.msg.sender);
    require a.isUserAuthorized(addr1) == ao.isUserAuthorized(addr1);
    require a.isUserAuthorized(addr2) == ao.isUserAuthorized(addr2);
    require a.isUserAuthorized(eA.msg.sender) == ao.isUserAuthorized(eA.msg.sender);
    
    require couplingInv();
    
    a.f(eA, args);
    ao.g(eAo, args);
    
    assert couplingInv();
    assert a.getBalance(addr1) == ao.getBalance(addr1);
    assert a.getBalance(addr2) == ao.getBalance(addr2);
    assert a.getBalance(addr3) == ao.getBalance(addr3);
    assert a.getBalance(eA.msg.sender) == ao.getBalance(eA.msg.sender);
    assert a.isUserAuthorized(addr1) == ao.isUserAuthorized(addr1);
    assert a.isUserAuthorized(addr2) == ao.isUserAuthorized(addr2);
    assert a.isUserAuthorized(eA.msg.sender) == ao.isUserAuthorized(eA.msg.sender);
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