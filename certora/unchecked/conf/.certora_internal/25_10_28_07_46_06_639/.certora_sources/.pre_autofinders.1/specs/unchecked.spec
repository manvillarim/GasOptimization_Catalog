using A as a;
using Ao as ao;

methods {
    // A methods
    function a.createStream(uint256) external returns (uint256);
    function a.withdraw(uint256, uint256) external;
    function a.batchAdd(address[], uint256) external;
    
    // Ao methods
    function ao.createStream(uint256) external returns (uint256);
    function ao.withdraw(uint256, uint256) external;
    function ao.batchAdd(address[], uint256) external;
}

definition couplingInv() returns bool =
    a._nextStreamId() == ao._nextStreamId() &&
    (forall uint256 idx. a.balances[idx] == ao.balances[idx]);

function gasOptimizationCorrectness(method f, method g) {
    env eA;
    env eAo;
    calldataarg args;
    
    require eA == eAo && couplingInv();
    
    a.f(eA, args);
    ao.g(eAo, args);
    
    assert couplingInv();
}

rule gasOptimizedCorrectnessOfCreateStream(method f, method g)
filtered {
    f -> f.selector == sig:a.createStream(uint256).selector,
    g -> g.selector == sig:ao.createStream(uint256).selector
} {
    gasOptimizationCorrectness(f, g);
}

rule gasOptimizedCorrectnessOfWithdraw(method f, method g)
filtered {
    f -> f.selector == sig:a.withdraw(uint256, uint256).selector,
    g -> g.selector == sig:ao.withdraw(uint256, uint256).selector
} {
    gasOptimizationCorrectness(f, g);
}

rule gasOptimizedCorrectnessOfBatchAdd(method f, method g)
filtered {
    f -> f.selector == sig:a.batchAdd(address[], uint256).selector,
    g -> g.selector == sig:ao.batchAdd(address[], uint256).selector
} {
    gasOptimizationCorrectness(f, g);
}