// SPDX-License-Identifier: BUSL-1.1
// Versão otimizada usando apenas os ghosts essenciais

using A as a;
using Ao as ao;

methods {
    function a.getUserAccruedRewards(address, address) external returns (uint256) envfree;
    function ao.getUserAccruedRewards(address, address) external returns (uint256) envfree;
    function a.getAllUserRewards(address[], address) external returns (address[], uint256[]) envfree;
    function ao.getAllUserRewards(address[], address) external returns (address[], uint256[]) envfree;
}

// ============================================================
// GHOSTS ESSENCIAIS
// ============================================================

// Capturar accrued rewards (o mais importante)
ghost mapping(address => mapping(address => mapping(address => mathint))) ghostAccrued_a;
ghost mapping(address => mapping(address => mapping(address => mathint))) ghostAccrued_ao;

// Capturar índices de usuário
ghost mapping(address => mapping(address => mapping(address => mathint))) ghostUserIndex_a;
ghost mapping(address => mapping(address => mapping(address => mathint))) ghostUserIndex_ao;

// Capturar tamanho das listas
ghost mathint ghostRewardsListLength_a;
ghost mathint ghostRewardsListLength_ao;

// ============================================================
// HOOKS MÍNIMOS
// ============================================================

// Accrued - A
hook Sstore a.rewardsDistributor._assets[KEY address asset]
    .rewards[KEY address reward]
    .usersData[KEY address user]
    .accrued uint128 newValue  {
    ghostAccrued_a[asset][reward][user] = newValue;
}

// Accrued - Ao
hook Sstore ao.rewardsDistributor._assets[KEY address asset]
    .rewards[KEY address reward]
    .usersData[KEY address user]
    .accrued uint128 newValue {
    ghostAccrued_ao[asset][reward][user] = newValue;
}

// User Index - A
hook Sstore a.rewardsDistributor._assets[KEY address asset]
    .rewards[KEY address reward]
    .usersData[KEY address user]
    .index uint104 newValue {
    ghostUserIndex_a[asset][reward][user] = newValue;
}

// User Index - Ao
hook Sstore ao.rewardsDistributor._assets[KEY address asset]
    .rewards[KEY address reward]
    .usersData[KEY address user]
    .index uint104 newValue {
    ghostUserIndex_ao[asset][reward][user] = newValue;
}

// Rewards List Length - A
hook Sload uint256 len a.rewardsDistributor._rewardsList.(offset 0)  {
    ghostRewardsListLength_a = len;
}

// Rewards List Length - Ao
hook Sload uint256 len ao.rewardsDistributor._rewardsList.(offset 0)  {
    ghostRewardsListLength_ao = len;
}

// ============================================================
// COUPLING INVARIANT SIMPLIFICADO
// ============================================================

definition couplingInv() returns bool =
    // Tamanhos das listas iguais
    ghostRewardsListLength_a == ghostRewardsListLength_ao &&
    
    // Para qualquer combinação asset-reward-user, os dados devem ser iguais
    (forall address asset. forall address reward. forall address user.
        ghostAccrued_a[asset][reward][user] == ghostAccrued_ao[asset][reward][user] &&
        ghostUserIndex_a[asset][reward][user] == ghostUserIndex_ao[asset][reward][user]
    );

// ============================================================
// FUNÇÃO GENÉRICA
// ============================================================

function gasOptimizationCorrectness(method f, method g) {
    env eA;
    env eAo;
    calldataarg args;
    
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
    env e;
    address user;
    address reward;
    
    uint256 resultA = a.getUserAccruedRewards(e, user, reward);
    uint256 resultAo = ao.getUserAccruedRewards(e, user, reward);
    
    assert resultA == resultAo, "Results differ";
}

rule gasOptimizedCorrectnessOfGetAllUserRewards(method f, method g)
filtered {
    f -> f.selector == sig:a.getAllUserRewards(address[], address).selector,
    g -> g.selector == sig:ao.getAllUserRewards(address[], address).selector
} {
    env e;
    address[] assets;
    address user;
    
    require assets.length <= 5;
    
    address[] rewardsA; uint256[] amountsA;
    address[] rewardsAo; uint256[] amountsAo;
    
    rewardsA, amountsA = a.getAllUserRewards(e, assets, user);
    rewardsAo, amountsAo = ao.getAllUserRewards(e, assets, user);
    
    assert rewardsA.length == rewardsAo.length, "Different lengths";
    assert amountsA.length == amountsAo.length, "Different amounts lengths";
    
    assert forall uint256 i. (i < rewardsA.length => rewardsA[i] == rewardsAo[i]), "Different rewards";
    assert forall uint256 i. (i < amountsA.length => amountsA[i] == amountsAo[i]), "Different amounts";
}