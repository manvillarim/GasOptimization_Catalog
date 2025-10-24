using A as a;
using Ao as ao;

methods {
    function transfer(address, uint256) external returns (bool);
    function approve(address, uint256) external returns (bool);
    function transferFrom(address, address, uint256) external returns (bool);
    function mint(address, uint256) external;
    function burn(uint256) external;
    function stake(uint256) external;
    function unstake() external;
    function addAdmin(address) external;
    function removeAdmin(address) external;
    function blacklistAddress(address) external;
    function unblacklistAddress(address) external;
    function pause() external;
    function unpause() external;
    function updateTransferLimits(uint256, uint256) external;
    function updateStakingParams(uint256, uint256) external;
    function emergencyWithdraw(address, uint256) external;
}

definition couplingInvariant() returns bool = 
    a.owner == ao.owner && 
    a.totalSupply == ao.totalSupply &&
    a.maxSupply == ao.maxSupply && 
    a.minTransferAmount == ao.minTransferAmount && 
    a.maxTransferAmount == ao.maxTransferAmount && 
    a.paused == ao.paused && 
    a.minStakeAmount == ao.minStakeAmount && 
    a.stakingDuration == ao.stakingDuration && 
    (forall address u. a.balances[u] == ao.balances[u]) &&
    (forall address u. forall address v. a.allowances[u][v] == ao.allowances[u][v]) && 
    (forall address u. a.stakedBalances[u] == ao.stakedBalances[u]) &&
    (forall address u. a.stakingTimestamps[u] == ao.stakingTimestamps[u]) && 
    (forall address u. a.admins[u] == ao.admins[u]) && 
    (forall address u. a.blacklisted[u] == ao.blacklisted[u]);

function gasOptimizationCorrectness(method f, method g) {
    env eA;
    env eAo;
    calldataarg args;
    require eA == eAo && couplingInvariant();
    a.f(eA, args);
    ao.g(eAo, args);
    assert couplingInvariant();
}

rule gasOptimizedCorrectnessOfTransfer(method f, method g)
filtered { f -> f.selector == sig:a.transfer(address, uint256).selector, g -> g.selector == sig:ao.transfer(address, uint256).selector } {
    gasOptimizationCorrectness(f, g);
}

rule gasOptimizedCorrectnessOfApprove(method f, method g)
filtered { f -> f.selector == sig:a.approve(address, uint256).selector, g -> g.selector == sig:ao.approve(address, uint256).selector } {
    gasOptimizationCorrectness(f, g);
}

rule gasOptimizedCorrectnessOfTransferFrom(method f, method g)
filtered { f -> f.selector == sig:a.transferFrom(address, address, uint256).selector, g -> g.selector == sig:ao.transferFrom(address, address, uint256).selector } {
    gasOptimizationCorrectness(f, g);
}

rule gasOptimizedCorrectnessOfMint(method f, method g)
filtered { f -> f.selector == sig:a.mint(address, uint256).selector, g -> g.selector == sig:ao.mint(address, uint256).selector } {
    gasOptimizationCorrectness(f, g);
}

rule gasOptimizedCorrectnessOfBurn(method f, method g)
filtered { f -> f.selector == sig:a.burn(uint256).selector, g -> g.selector == sig:ao.burn(uint256).selector } {
    gasOptimizationCorrectness(f, g);
}

rule gasOptimizedCorrectnessOfStake(method f, method g)
filtered { f -> f.selector == sig:a.stake(uint256).selector, g -> g.selector == sig:ao.stake(uint256).selector } {
    gasOptimizationCorrectness(f, g);
}

rule gasOptimizedCorrectnessOfUnstake(method f, method g)
filtered { f -> f.selector == sig:a.unstake().selector, g -> g.selector == sig:ao.unstake().selector } {
    gasOptimizationCorrectness(f, g);
}

rule gasOptimizedCorrectnessOfAddAdmin(method f, method g)
filtered { f -> f.selector == sig:a.addAdmin(address).selector, g -> g.selector == sig:ao.addAdmin(address).selector } {
    gasOptimizationCorrectness(f, g);
}

rule gasOptimizedCorrectnessOfRemoveAdmin(method f, method g)
filtered { f -> f.selector == sig:a.removeAdmin(address).selector, g -> g.selector == sig:ao.removeAdmin(address).selector } {
    gasOptimizationCorrectness(f, g);
}

rule gasOptimizedCorrectnessOfBlacklistAddress(method f, method g)
filtered { f -> f.selector == sig:a.blacklistAddress(address).selector, g -> g.selector == sig:ao.blacklistAddress(address).selector } {
    gasOptimizationCorrectness(f, g);
}

rule gasOptimizedCorrectnessOfUnblacklistAddress(method f, method g)
filtered { f -> f.selector == sig:a.unblacklistAddress(address).selector, g -> g.selector == sig:ao.unblacklistAddress(address).selector } {
    gasOptimizationCorrectness(f, g);
}

rule gasOptimizedCorrectnessOfPause(method f, method g)
filtered { f -> f.selector == sig:a.pause().selector, g -> g.selector == sig:ao.pause().selector } {
    gasOptimizationCorrectness(f, g);
}

rule gasOptimizedCorrectnessOfUnpause(method f, method g)
filtered { f -> f.selector == sig:a.unpause().selector, g -> g.selector == sig:ao.unpause().selector } {
    gasOptimizationCorrectness(f, g);
}

rule gasOptimizedCorrectnessOfUpdateTransferLimits(method f, method g)
filtered { f -> f.selector == sig:a.updateTransferLimits(uint256, uint256).selector, g -> g.selector == sig:ao.updateTransferLimits(uint256, uint256).selector } {
    gasOptimizationCorrectness(f, g);
}

rule gasOptimizedCorrectnessOfUpdateStakingParams(method f, method g)
filtered { f -> f.selector == sig:a.updateStakingParams(uint256, uint256).selector, g -> g.selector == sig:ao.updateStakingParams(uint256, uint256).selector } {
    gasOptimizationCorrectness(f, g);
}


