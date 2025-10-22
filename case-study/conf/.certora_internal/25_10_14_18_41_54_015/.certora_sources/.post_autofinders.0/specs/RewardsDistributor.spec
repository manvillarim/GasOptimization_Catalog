using RewardsDistributorOriginal as a;
using RewardsDistributorOptimized as ao;

methods {
    function a.getUserAccruedRewards(address, address) external returns (uint256) envfree;
    function ao.getUserAccruedRewards(address, address) external returns (uint256) envfree;
    
    function a.getAllUserRewards(address[], address) external returns (address[], uint256[]);
    function ao.getAllUserRewards(address[], address) external returns (address[], uint256[]);
    
    function a.getUserRewards(address[], address, address) external returns (uint256);
    function ao.getUserRewards(address[], address, address) external returns (uint256);
    
    function a.getRewardsData(address, address) external returns (uint256, uint256, uint256, uint256) envfree;
    function ao.getRewardsData(address, address) external returns (uint256, uint256, uint256, uint256) envfree;
    
    function a.getAssetIndex(address, address) external returns (uint256, uint256);
    function ao.getAssetIndex(address, address) external returns (uint256, uint256);
    
    function a.getDistributionEnd(address, address) external returns (uint256) envfree;
    function ao.getDistributionEnd(address, address) external returns (uint256) envfree;
    
    function a.getRewardsByAsset(address) external returns (address[]) envfree;
    function ao.getRewardsByAsset(address) external returns (address[]) envfree;
    
    function a.getRewardsList() external returns (address[]) envfree;
    function ao.getRewardsList() external returns (address[]) envfree;
    
    function a.getUserAssetIndex(address, address, address) external returns (uint256) envfree;
    function ao.getUserAssetIndex(address, address, address) external returns (uint256) envfree;
    
    function a.getAssetDecimals(address) external returns (uint8) envfree;
    function ao.getAssetDecimals(address) external returns (uint8) envfree;
    
    function a.getEmissionManager() external returns (address) envfree;
    function ao.getEmissionManager() external returns (address) envfree;
    
    function a.setDistributionEnd(address, address, uint32) external;
    function ao.setDistributionEnd(address, address, uint32) external;
    
    function a.setEmissionPerSecond(address, address[], uint88[]) external;
    function ao.setEmissionPerSecond(address, address[], uint88[]) external;
}

// Ghost UserData
ghost mapping(address => mapping(address => mapping(address => uint104))) ghost_a_userIndex {
    init_state axiom forall address asset. forall address reward. forall address user.
        ghost_a_userIndex[asset][reward][user] == 0;
}

ghost mapping(address => mapping(address => mapping(address => uint128))) ghost_a_userAccrued {
    init_state axiom forall address asset. forall address reward. forall address user.
        ghost_a_userAccrued[asset][reward][user] == 0;
}

// Ghost RewardData
ghost mapping(address => mapping(address => uint104)) ghost_a_rewardIndex {
    init_state axiom forall address asset. forall address reward.
        ghost_a_rewardIndex[asset][reward] == 0;
}

ghost mapping(address => mapping(address => uint88)) ghost_a_emissionPerSecond {
    init_state axiom forall address asset. forall address reward.
        ghost_a_emissionPerSecond[asset][reward] == 0;
}

ghost mapping(address => mapping(address => uint32)) ghost_a_lastUpdateTimestamp {
    init_state axiom forall address asset. forall address reward.
        ghost_a_lastUpdateTimestamp[asset][reward] == 0;
}

ghost mapping(address => mapping(address => uint32)) ghost_a_distributionEnd {
    init_state axiom forall address asset. forall address reward.
        ghost_a_distributionEnd[asset][reward] == 0;
}

// Ghost AssetData
ghost mapping(address => uint8) ghost_a_assetDecimals {
    init_state axiom forall address asset.
        ghost_a_assetDecimals[asset] == 0;
}

ghost mapping(address => uint128) ghost_a_availableRewardsCount {
    init_state axiom forall address asset.
        ghost_a_availableRewardsCount[asset] == 0;
}

ghost mapping(address => mapping(uint128 => address)) ghost_a_availableRewards {
    init_state axiom forall address asset. forall uint128 idx.
        ghost_a_availableRewards[asset][idx] == 0;
}


// Ghost UserData
ghost mapping(address => mapping(address => mapping(address => uint104))) ghost_ao_userIndex {
    init_state axiom forall address asset. forall address reward. forall address user.
        ghost_ao_userIndex[asset][reward][user] == 0;
}

ghost mapping(address => mapping(address => mapping(address => uint128))) ghost_ao_userAccrued {
    init_state axiom forall address asset. forall address reward. forall address user.
        ghost_ao_userAccrued[asset][reward][user] == 0;
}

// Ghost  RewardData
ghost mapping(address => mapping(address => uint104)) ghost_ao_rewardIndex {
    init_state axiom forall address asset. forall address reward.
        ghost_ao_rewardIndex[asset][reward] == 0;
}

ghost mapping(address => mapping(address => uint88)) ghost_ao_emissionPerSecond {
    init_state axiom forall address asset. forall address reward.
        ghost_ao_emissionPerSecond[asset][reward] == 0;
}

ghost mapping(address => mapping(address => uint32)) ghost_ao_lastUpdateTimestamp {
    init_state axiom forall address asset. forall address reward.
        ghost_ao_lastUpdateTimestamp[asset][reward] == 0;
}

ghost mapping(address => mapping(address => uint32)) ghost_ao_distributionEnd {
    init_state axiom forall address asset. forall address reward.
        ghost_ao_distributionEnd[asset][reward] == 0;
}

// Ghost para AssetData
ghost mapping(address => uint8) ghost_ao_assetDecimals {
    init_state axiom forall address asset.
        ghost_ao_assetDecimals[asset] == 0;
}

ghost mapping(address => uint128) ghost_ao_availableRewardsCount {
    init_state axiom forall address asset.
        ghost_ao_availableRewardsCount[asset] == 0;
}

ghost mapping(address => mapping(uint128 => address)) ghost_ao_availableRewards {
    init_state axiom forall address asset. forall uint128 idx.
        ghost_ao_availableRewards[asset][idx] == 0;
}


// Hooks A
hook Sstore a._assets[KEY address asset].rewards[KEY address reward].usersData[KEY address user].index uint104 newValue (uint104 oldValue) {
    ghost_a_userIndex[asset][reward][user] = newValue;
}

hook Sload uint104 val a._assets[KEY address asset].rewards[KEY address reward].usersData[KEY address user].index {
    require ghost_a_userIndex[asset][reward][user] == val;
}

hook Sstore a._assets[KEY address asset].rewards[KEY address reward].usersData[KEY address user].accrued uint128 newValue (uint128 oldValue) {
    ghost_a_userAccrued[asset][reward][user] = newValue;
}

hook Sload uint128 val a._assets[KEY address asset].rewards[KEY address reward].usersData[KEY address user].accrued {
    require ghost_a_userAccrued[asset][reward][user] == val;
}

hook Sstore a._assets[KEY address asset].rewards[KEY address reward].index uint104 newValue (uint104 oldValue) {
    ghost_a_rewardIndex[asset][reward] = newValue;
}

hook Sload uint104 val a._assets[KEY address asset].rewards[KEY address reward].index {
    require ghost_a_rewardIndex[asset][reward] == val;
}

hook Sstore a._assets[KEY address asset].rewards[KEY address reward].emissionPerSecond uint88 newValue (uint88 oldValue) {
    ghost_a_emissionPerSecond[asset][reward] = newValue;
}

hook Sload uint88 val a._assets[KEY address asset].rewards[KEY address reward].emissionPerSecond {
    require ghost_a_emissionPerSecond[asset][reward] == val;
}

hook Sstore a._assets[KEY address asset].rewards[KEY address reward].lastUpdateTimestamp uint32 newValue (uint32 oldValue) {
    ghost_a_lastUpdateTimestamp[asset][reward] = newValue;
}

hook Sload uint32 val a._assets[KEY address asset].rewards[KEY address reward].lastUpdateTimestamp {
    require ghost_a_lastUpdateTimestamp[asset][reward] == val;
}

hook Sstore a._assets[KEY address asset].rewards[KEY address reward].distributionEnd uint32 newValue (uint32 oldValue) {
    ghost_a_distributionEnd[asset][reward] = newValue;
}

hook Sload uint32 val a._assets[KEY address asset].rewards[KEY address reward].distributionEnd {
    require ghost_a_distributionEnd[asset][reward] == val;
}

hook Sstore a._assets[KEY address asset].decimals uint8 newValue (uint8 oldValue) {
    ghost_a_assetDecimals[asset] = newValue;
}

hook Sload uint8 val a._assets[KEY address asset].decimals {
    require ghost_a_assetDecimals[asset] == val;
}

hook Sstore a._assets[KEY address asset].availableRewardsCount uint128 newValue (uint128 oldValue) {
    ghost_a_availableRewardsCount[asset] = newValue;
}

hook Sload uint128 val a._assets[KEY address asset].availableRewardsCount {
    require ghost_a_availableRewardsCount[asset] == val;
}

// Hooks Ao
hook Sstore ao._assets[KEY address asset].rewards[KEY address reward].usersData[KEY address user].index uint104 newValue (uint104 oldValue) {
    ghost_ao_userIndex[asset][reward][user] = newValue;
}

hook Sload uint104 val ao._assets[KEY address asset].rewards[KEY address reward].usersData[KEY address user].index {
    require ghost_ao_userIndex[asset][reward][user] == val;
}

hook Sstore ao._assets[KEY address asset].rewards[KEY address reward].usersData[KEY address user].accrued uint128 newValue (uint128 oldValue) {
    ghost_ao_userAccrued[asset][reward][user] = newValue;
}

hook Sload uint128 val ao._assets[KEY address asset].rewards[KEY address reward].usersData[KEY address user].accrued {
    require ghost_ao_userAccrued[asset][reward][user] == val;
}

hook Sstore ao._assets[KEY address asset].rewards[KEY address reward].index uint104 newValue (uint104 oldValue) {
    ghost_ao_rewardIndex[asset][reward] = newValue;
}

hook Sload uint104 val ao._assets[KEY address asset].rewards[KEY address reward].index {
    require ghost_ao_rewardIndex[asset][reward] == val;
}

hook Sstore ao._assets[KEY address asset].rewards[KEY address reward].emissionPerSecond uint88 newValue (uint88 oldValue) {
    ghost_ao_emissionPerSecond[asset][reward] = newValue;
}

hook Sload uint88 val ao._assets[KEY address asset].rewards[KEY address reward].emissionPerSecond {
    require ghost_ao_emissionPerSecond[asset][reward] == val;
}

hook Sstore ao._assets[KEY address asset].rewards[KEY address reward].lastUpdateTimestamp uint32 newValue (uint32 oldValue) {
    ghost_ao_lastUpdateTimestamp[asset][reward] = newValue;
}

hook Sload uint32 val ao._assets[KEY address asset].rewards[KEY address reward].lastUpdateTimestamp {
    require ghost_ao_lastUpdateTimestamp[asset][reward] == val;
}

hook Sstore ao._assets[KEY address asset].rewards[KEY address reward].distributionEnd uint32 newValue (uint32 oldValue) {
    ghost_ao_distributionEnd[asset][reward] = newValue;
}

hook Sload uint32 val ao._assets[KEY address asset].rewards[KEY address reward].distributionEnd {
    require ghost_ao_distributionEnd[asset][reward] == val;
}

hook Sstore ao._assets[KEY address asset].decimals uint8 newValue (uint8 oldValue) {
    ghost_ao_assetDecimals[asset] = newValue;
}

hook Sload uint8 val ao._assets[KEY address asset].decimals {
    require ghost_ao_assetDecimals[asset] == val;
}

hook Sstore ao._assets[KEY address asset].availableRewardsCount uint128 newValue (uint128 oldValue) {
    ghost_ao_availableRewardsCount[asset] = newValue;
}

hook Sload uint128 val ao._assets[KEY address asset].availableRewardsCount {
    require ghost_ao_availableRewardsCount[asset] == val;
}


definition CouplingInv() returns bool =
    // UserData coupling
    (forall address asset. forall address reward. forall address user.
        ghost_a_userIndex[asset][reward][user] == ghost_ao_userIndex[asset][reward][user] &&
        ghost_a_userAccrued[asset][reward][user] == ghost_ao_userAccrued[asset][reward][user]
    ) &&
    
    // RewardData coupling
    (forall address asset. forall address reward.
        ghost_a_rewardIndex[asset][reward] == ghost_ao_rewardIndex[asset][reward] &&
        ghost_a_emissionPerSecond[asset][reward] == ghost_ao_emissionPerSecond[asset][reward] &&
        ghost_a_lastUpdateTimestamp[asset][reward] == ghost_ao_lastUpdateTimestamp[asset][reward] &&
        ghost_a_distributionEnd[asset][reward] == ghost_ao_distributionEnd[asset][reward]
    ) &&
    
    // AssetData coupling
    (forall address asset.
        ghost_a_assetDecimals[asset] == ghost_ao_assetDecimals[asset] &&
        ghost_a_availableRewardsCount[asset] == ghost_ao_availableRewardsCount[asset]
    ) &&
    
    // AvailableRewards coupling
    (forall address asset. forall uint128 idx.
        ghost_a_availableRewards[asset][idx] == ghost_ao_availableRewards[asset][idx]
    );


function GasOptimizationCorrectness(method f, method g) {
    env eA;
    env eAo;
    calldataarg args;
    
    require eA.msg.sender == eAo.msg.sender;
    require eA.msg.value == eAo.msg.value;
    require eA.block.timestamp == eAo.block.timestamp;
    
    require CouplingInv();
    
    a.f(eA, args);
    ao.g(eAo, args);
    
    assert CouplingInv();
}


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


rule gasOptimizedCorrectnessOfGetUserAccruedRewards(method f, method g)
filtered {
    f -> f.selector == sig:a.getUserAccruedRewards(address, address).selector,
    g -> g.selector == sig:ao.getUserAccruedRewards(address, address).selector
} {
    gasOptimizationCorrectness(f, g);
}

rule gasOptimizedCorrectnessOfGetAllUserRewards(method f, method g)
filtered {
    f -> f.selector == sig:a.getAllUserRewards(address[], address).selector,
    g -> g.selector == sig:ao.getAllUserRewards(address[], address).selector
} {
    gasOptimizationCorrectness(f, g);
}

rule gasOptimizedCorrectnessOfGetUserRewards(method f, method g)
filtered {
    f -> f.selector == sig:a.getUserRewards(address[], address, address).selector,
    g -> g.selector == sig:ao.getUserRewards(address[], address, address).selector
} {
    gasOptimizationCorrectness(f, g);
}

rule gasOptimizedCorrectnessOfGetRewardsData(method f, method g)
filtered {
    f -> f.selector == sig:a.getRewardsData(address, address).selector,
    g -> g.selector == sig:ao.getRewardsData(address, address).selector
} {
    gasOptimizationCorrectness(f, g);
}

rule gasOptimizedCorrectnessOfGetAssetIndex(method f, method g)
filtered {
    f -> f.selector == sig:a.getAssetIndex(address, address).selector,
    g -> g.selector == sig:ao.getAssetIndex(address, address).selector
} {
    gasOptimizationCorrectness(f, g);
}

rule gasOptimizedCorrectnessOfGetDistributionEnd(method f, method g)
filtered {
    f -> f.selector == sig:a.getDistributionEnd(address, address).selector,
    g -> g.selector == sig:ao.getDistributionEnd(address, address).selector
} {
    gasOptimizationCorrectness(f, g);
}

rule gasOptimizedCorrectnessOfGetRewardsByAsset(method f, method g)
filtered {
    f -> f.selector == sig:a.getRewardsByAsset(address).selector,
    g -> g.selector == sig:ao.getRewardsByAsset(address).selector
} {
    gasOptimizationCorrectness(f, g);
}

rule gasOptimizedCorrectnessOfGetRewardsList(method f, method g)
filtered {
    f -> f.selector == sig:a.getRewardsList().selector,
    g -> g.selector == sig:ao.getRewardsList().selector
} {
    gasOptimizationCorrectness(f, g);
}

rule gasOptimizedCorrectnessOfGetUserAssetIndex(method f, method g)
filtered {
    f -> f.selector == sig:a.getUserAssetIndex(address, address, address).selector,
    g -> g.selector == sig:ao.getUserAssetIndex(address, address, address).selector
} {
    gasOptimizationCorrectness(f, g);
}

rule gasOptimizedCorrectnessOfGetAssetDecimals(method f, method g)
filtered {
    f -> f.selector == sig:a.getAssetDecimals(address).selector,
    g -> g.selector == sig:ao.getAssetDecimals(address).selector
} {
    gasOptimizationCorrectness(f, g);
}

rule gasOptimizedCorrectnessOfGetEmissionManager(method f, method g)
filtered {
    f -> f.selector == sig:a.getEmissionManager().selector,
    g -> g.selector == sig:ao.getEmissionManager().selector
} {
    gasOptimizationCorrectness(f, g);
}

rule gasOptimizedCorrectnessOfSetDistributionEnd(method f, method g)
filtered {
    f -> f.selector == sig:a.setDistributionEnd(address, address, uint32).selector,
    g -> g.selector == sig:ao.setDistributionEnd(address, address, uint32).selector
} {
    gasOptimizationCorrectness(f, g);
}

rule gasOptimizedCorrectnessOfSetEmissionPerSecond(method f, method g)
filtered {
    f -> f.selector == sig:a.setEmissionPerSecond(address, address[], uint88[]).selector,
    g -> g.selector == sig:ao.setEmissionPerSecond(address, address[], uint88[]).selector
} {
    gasOptimizationCorrectness(f, g);
}