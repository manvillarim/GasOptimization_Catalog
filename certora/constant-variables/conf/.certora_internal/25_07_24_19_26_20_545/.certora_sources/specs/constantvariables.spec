using A as a;
using Ao as ao;

methods {
    function a.balances(address) external returns (uint256) envfree;
    function ao.balances(address) external returns (uint256) envfree;
    function a.allowances(address,address) external returns (uint256) envfree;
    function ao.allowances(address,address) external returns (uint256) envfree;
    function a.isPaused() external returns (bool) envfree;
    function ao.isPaused() external returns (bool) envfree;
    function a.totalSupply() external returns (uint256) envfree;
    function ao.TOTAL_SUPPLY() external returns (uint256) envfree;
    function a.owner() external returns (address) envfree;
    function ao.OWNER() external returns (address) envfree;
    function a.mintingFee() external returns (uint256) envfree;
    function ao.MINTING_FEE() external returns (uint256) envfree;
    function a.maxTransactionAmount() external returns (uint256) envfree;
    function ao.MAX_TRANSACTION_AMOUNT() external returns (uint256) envfree;
}

definition couplingInv() returns bool =
    a.isPaused() == ao.isPaused() &&
    a.totalSupply() == ao.TOTAL_SUPPLY() &&
    a.owner() == ao.OWNER() &&
    a.mintingFee() == ao.MINTING_FEE() &&
    a.maxTransactionAmount() == ao.MAX_TRANSACTION_AMOUNT();

function gasOptimizationCorrectness(method f, method g) {
    env eA;
    env eAo;
    calldataarg args;
    
    require eA.msg.sender == eAo.msg.sender;
    require eA.msg.value == eAo.msg.value;
    require eA.block.timestamp == eAo.block.timestamp;
    
    address addr1; address addr2;
    require a.balances(addr1) == ao.balances(addr1);
    require a.balances(addr2) == ao.balances(addr2);
    require a.balances(eA.msg.sender) == ao.balances(eA.msg.sender);
    require a.allowances(addr1, addr2) == ao.allowances(addr1, addr2);
    require a.allowances(eA.msg.sender, addr1) == ao.allowances(eA.msg.sender, addr1);
    require a.allowances(addr1, eA.msg.sender) == ao.allowances(addr1, eA.msg.sender);
    
    require couplingInv();
    
    a.f(eA, args);
    ao.g(eAo, args);
    
    assert couplingInv();
    assert a.balances(addr1) == ao.balances(addr1);
    assert a.balances(addr2) == ao.balances(addr2);
    assert a.balances(eA.msg.sender) == ao.balances(eA.msg.sender);
    assert a.allowances(addr1, addr2) == ao.allowances(addr1, addr2);
    assert a.allowances(eA.msg.sender, addr1) == ao.allowances(eA.msg.sender, addr1);
    assert a.allowances(addr1, eA.msg.sender) == ao.allowances(addr1, eA.msg.sender);
}

rule gasOptimizedCorrectnessOfTransfer(method f, method g)
filtered {
    f -> f.selector == sig:a.transfer(address,uint256).selector,
    g -> g.selector == sig:ao.transfer(address,uint256).selector
} {
    gasOptimizationCorrectness(f, g);
}

rule gasOptimizedCorrectnessOfGetBasicInfo(method f, method g)
filtered {
    f -> f.selector == sig:a.getBasicInfo().selector,
    g -> g.selector == sig:ao.getBasicInfo().selector
} {
    gasOptimizationCorrectness(f, g);
}

rule gasOptimizedCorrectnessOfGetSupplyInfo(method f, method g)
filtered {
    f -> f.selector == sig:a.getSupplyInfo().selector,
    g -> g.selector == sig:ao.getSupplyInfo().selector
} {
    gasOptimizationCorrectness(f, g);
}

rule gasOptimizedCorrectnessOfGetOwnerAndFee(method f, method g)
filtered {
    f -> f.selector == sig:a.getOwnerAndFee().selector,
    g -> g.selector == sig:ao.getOwnerAndFee().selector
} {
    gasOptimizationCorrectness(f, g);
}

rule gasOptimizedCorrectnessOfCheckLimits(method f, method g)
filtered {
    f -> f.selector == sig:a.checkLimits(uint256).selector,
    g -> g.selector == sig:ao.checkLimits(uint256).selector
} {
    gasOptimizationCorrectness(f, g);
}

rule gasOptimizedCorrectnessOfCalculateFees(method f, method g)
filtered {
    f -> f.selector == sig:a.calculateFees(uint256).selector,
    g -> g.selector == sig:ao.calculateFees(uint256).selector
} {
    gasOptimizationCorrectness(f, g);
}