using CollectorOriginal as a;
using CollectorOptimized as ao;

methods {
    // Admin functions
    function a.approve(address, address, uint256) external;
    function ao.approve(address, address, uint256) external;
    
    function a.transfer(address, address, uint256) external;
    function ao.transfer(address, address, uint256) external;
    
    // Stream functions
    function a.createStream(address, uint256, address, uint256, uint256) external returns (uint256);
    function ao.createStream(address, uint256, address, uint256, uint256) external returns (uint256);
    
    function a.withdrawFromStream(uint256, uint256) external returns (bool);
    function ao.withdrawFromStream(uint256, uint256) external returns (bool);
    
    function a.cancelStream(uint256) external returns (bool);
    function ao.cancelStream(uint256) external returns (bool);
    
    // View functions
    function a.isFundsAdmin(address) external returns (bool) envfree;
    function ao.isFundsAdmin(address) external returns (bool) envfree;
    
    function a.getNextStreamId() external returns (uint256) envfree;
    function ao.getNextStreamId() external returns (uint256) envfree;
    
    function a.deltaOf(uint256) external returns (uint256) envfree;
    function ao.deltaOf(uint256) external returns (uint256) envfree;
    
    function a.balanceOf(uint256, address) external returns (uint256) envfree;
    function ao.balanceOf(uint256, address) external returns (uint256) envfree;
}

definition couplingInv() returns bool =
    a._nextStreamId == ao._nextStreamId &&
    
    (forall uint256 streamId.
        a._streams[streamId].sender == ao._streams[streamId].sender &&
        a._streams[streamId].recipient == ao._streams[streamId].recipient &&
        a._streams[streamId].deposit == ao._streams[streamId].deposit &&
        a._streams[streamId].tokenAddress == ao._streams[streamId].tokenAddress &&
        a._streams[streamId].startTime == ao._streams[streamId].startTime &&
        a._streams[streamId].stopTime == ao._streams[streamId].stopTime &&
        a._streams[streamId].remainingBalance == ao._streams[streamId].remainingBalance &&
        a._streams[streamId].ratePerSecond == ao._streams[streamId].ratePerSecond &&
        a._streams[streamId].isEntity == ao._streams[streamId].isEntity
    );

function gasOptimizationCorrectness(method f, method g) {
    env eA;
    env eAo;
    calldataarg args;
    
    require eA.msg.sender == eAo.msg.sender;
    require eA.msg.value == eAo.msg.value;
    require eA.block.timestamp == eAo.block.timestamp;
    
    require couplingInv();
    
    a.f(eA, args);
    ao.g(eAo, args);
    
    assert couplingInv();
}

rule gasOptimizedCorrectnessOfApprove(method f, method g)
filtered {
    f -> f.selector == sig:a.approve(address, address, uint256).selector,
    g -> g.selector == sig:ao.approve(address, address, uint256).selector
} {
    gasOptimizationCorrectness(f, g);
}

rule gasOptimizedCorrectnessOfTransfer(method f, method g)
filtered {
    f -> f.selector == sig:a.transfer(address, address, uint256).selector,
    g -> g.selector == sig:ao.transfer(address, address, uint256).selector
} {
    gasOptimizationCorrectness(f, g);
}

rule gasOptimizedCorrectnessOfCreateStream(method f, method g)
filtered {
    f -> f.selector == sig:a.createStream(address, uint256, address, uint256, uint256).selector,
    g -> g.selector == sig:ao.createStream(address, uint256, address, uint256, uint256).selector
} {
    gasOptimizationCorrectness(f, g);
}

rule gasOptimizedCorrectnessOfWithdrawFromStream(method f, method g)
filtered {
    f -> f.selector == sig:a.withdrawFromStream(uint256, uint256).selector,
    g -> g.selector == sig:ao.withdrawFromStream(uint256, uint256).selector
} {
    gasOptimizationCorrectness(f, g);
}

rule gasOptimizedCorrectnessOfCancelStream(method f, method g)
filtered {
    f -> f.selector == sig:a.cancelStream(uint256).selector,
    g -> g.selector == sig:ao.cancelStream(uint256).selector
} {
    gasOptimizationCorrectness(f, g);
}